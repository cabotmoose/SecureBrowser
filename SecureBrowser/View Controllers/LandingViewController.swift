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
	
	let biometricAuth = BiometricIDAuth()
	private let serviceName = "SecureBrowser"
	private let accountName = "primary"
	var newAccount = true
	
	var currentDot = 4
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// Setup NumberPadView
		let numPad = NumberPadView(frame: numberPadPlaceholder.frame, delegate: self)
		numPad.backgroundColor = UIColor.clear
		view.addSubview(numPad)
	}
	
	@objc func buttonPressed(_ sender:UIButton) {
		print("Button pressed")
	}
	
	func incrementTapped() {
		guard currentDot > 0 else {
			let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewController(withIdentifier: "BrowserViewController") as! BrowserViewController
			self.show(vc, sender: self)
//			dotRow.clearDots()
//			currentDot = 4
			return
		}
		
		dotRow.selectDot(at: currentDot)
		currentDot -= 1
	}
}

extension LandingViewController: NumberPadViewDelegate {
	func didPressNumber(number: Int) {
		print("received didPressNumber call for: \(number)")
		incrementTapped()
	}
}
