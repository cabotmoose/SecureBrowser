//
//  LoginViewController.swift
//  SecureBrowser
//
//  Created by Cameron Smith on 2/6/18.
//  Copyright © 2018 Flying Moose Development. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var biometricButton: UIButton!
	
	let biometricAuth = BiometricIDAuth()
	private let serviceName = "SecureBrowser"
	private let accountName = "primary"
	var newAccount = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let hasProfile = UserDefaults.standard.bool(forKey: "hasProfile")
		
		if hasProfile {
			newAccount = false
			loginButton.setTitle("Login", for: .normal)
		} else {
			loginButton.setTitle("Create Password", for: .normal)
		}
		
		// Setup for Touch/Face ID authentication
		biometricButton.isHidden = !biometricAuth.canEvaluatePolicy()
		
		switch biometricAuth.biometricType() {
		case .faceID:
			biometricButton.setImage(UIImage(named: "FaceIcon"), for: .normal)
		default:
			biometricButton.setImage(UIImage(named: "Touch-icon-lg"), for: .normal)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Automatically launch Touch/Face ID prompt upon load if available
		if biometricAuth.canEvaluatePolicy() {
			biometricButtonTapped(self)
		}
	}
	
	//MARK: IBActions
	@IBAction func backgroundButtonTapped(_ sender: Any) {
		passwordTextField.resignFirstResponder()
	}
	
	@IBAction func loginButtonTapped(_ sender: Any) {
		guard let newPassword = passwordTextField.text, !newPassword.isEmpty else {
			showErrorAlert()
			return
		}
		
		passwordTextField.resignFirstResponder()
		
		if newAccount {
			do {
				let passwordItem = KeychainPasswordItem(service: serviceName, account: accountName)
				try passwordItem.savePassword(newPassword)
			} catch {
				fatalError("Error updating keychain: \(error)")
			}
			
			UserDefaults.standard.set(true, forKey: "hasProfile")
			performSegue(withIdentifier: "dismissLogin", sender: self)
		} else {
			if checkPassword(password: newPassword) {
				performSegue(withIdentifier: "dismissLogin", sender: self)
			}
		}
	}
	
	@IBAction func biometricButtonTapped(_ sender: Any) {
		biometricAuth.authenticateUser() { [weak self] message in
			if let message = message {
				let alertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
				let okAction = UIAlertAction(title: "Dismiss", style: .default)
				alertView.addAction(okAction)
				self?.present(alertView, animated: true)
			} else {
				self?.performSegue(withIdentifier: "dismissLogin", sender: self)
			}
		}
	}
	
	//MARK: Private methods
	private func showErrorAlert() {
		let alertView = UIAlertController(title: "Error", message: "Invalid password", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default)
		alertView.addAction(okAction)
		present(alertView, animated: true)
	}
	
	private func checkPassword(password:String) -> Bool {
		do {
			let passwordItem = KeychainPasswordItem(service: serviceName, account: accountName)
			let keychainPassword = try passwordItem.readPassword()
			return password == keychainPassword
		} catch {
			fatalError("Error retrieving password from Keychain: \(error)")
		}
	}
}
