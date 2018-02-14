//
//  LandingViewController.swift
//  SecureBrowser
//
//  Created by Cameron Smith on 2/12/18.
//  Copyright © 2018 Flying Moose Development. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
	@IBOutlet weak var dotRow: DotRow!
	@IBOutlet weak var numberPadPlaceholder: UIView!
	@IBOutlet weak var pinLabel: UILabel!
	var biometricButton:UIButton!
	
	let biometricAuth = BiometricIDAuth()
	private let serviceName = "SecureBrowser"
	private let accountName = "primary"
	var newAccount = true
	
	var currentDot = 4
	
	private var pinEntry:String = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let hasProfile = UserDefaults.standard.bool(forKey: "hasProfile")
		
		if hasProfile {
			newAccount = false
		} else {
			pinLabel.text = "Create PIN"
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// Setup NumberPadView
		let numPad = NumberPadView(frame: numberPadPlaceholder.frame, delegate: self)
		numPad.backgroundColor = UIColor.clear
		view.addSubview(numPad)
		
//		if biometricAuth.canEvaluatePolicy() {
//			setupBiometricButton()
//		}
	}
	
	func segueToBrowser() {
		let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "BrowserViewController") as! BrowserViewController
		self.show(vc, sender: self)
	}
	
	func setupBiometricButton() {
		let biometricButtonFrame = CGRect(x: numberPadPlaceholder.frame.origin.x, y: (numberPadPlaceholder.frame.size.height/4)*3, width: numberPadPlaceholder.frame.size.width/3, height: numberPadPlaceholder.frame.size.height/4)
		biometricButton = UIButton(frame: biometricButtonFrame)
		biometricButton.addTarget(self, action: #selector(LandingViewController.biometricButtonTapped(_:)), for: .touchUpInside)
		
		switch biometricAuth.biometricType() {
		case .faceID:
			biometricButton.setImage(UIImage(named: "FaceIcon"), for: .normal)
		default:
			biometricButton.setImage(UIImage(named: "Touch-icon-lg"), for: .normal)
		}
		view.addSubview(biometricButton)
	}
	
	@objc func biometricButtonTapped(_ sender: Any) {
		biometricAuth.authenticateUser() { [weak self] message in
			if let message = message {
				let alertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
				let okAction = UIAlertAction(title: "Dismiss", style: .default)
				alertView.addAction(okAction)
				self?.present(alertView, animated: true)
			} else {
				self?.segueToBrowser()
			}
		}
	}
	
	@objc func buttonPressed(_ sender:UIButton) {
		print("Button pressed")
	}
	
	func incrementTapped() {
		guard currentDot > 0 else {
			segueToBrowser()
//			dotRow.clearDots()
//			currentDot = 4
			return
		}
		
		dotRow.selectDot(at: currentDot)
		currentDot -= 1
	}
	
	//MARK: Private methods
	private func showErrorAlert() {
		pinEntry = ""
		dotRow.clearDots()
		currentDot = 4
		
		let alertView = UIAlertController(title: "Error", message: "Invalid passcode", preferredStyle: .alert)
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

extension LandingViewController: NumberPadViewDelegate {
	func didPressNumber(number: Int) {
		pinEntry.append("\(number)")
		print("pinEntry: \(pinEntry)")
		dotRow.selectDot(at: currentDot)
		currentDot -= 1
		
		guard currentDot > 0 else {
			if newAccount {
				do {
					let passwordItem = KeychainPasswordItem(service: serviceName, account: accountName)
					try passwordItem.savePassword(pinEntry)
				} catch {
					fatalError("Error updating keychain: \(error)")
				}
				UserDefaults.standard.set(true, forKey: "hasProfile")
			}
			//validate passcode
			checkPassword(password: pinEntry) ? segueToBrowser() : showErrorAlert()
			return
		}
	}
}
