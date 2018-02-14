//
//  BiometricAuthentication.swift
//  SecureBrowser
//
//  Created by Cameron Smith on 2/6/18.
//  Copyright © 2018 Flying Moose Development. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometricType {
	case none
	case touchID
	case faceID
}

class BiometricIDAuth {
	let context = LAContext()
	var loginReason = "Logging in with Touch ID"
	
	func canEvaluatePolicy() -> Bool {
		return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
	}
	
	func biometricType() -> BiometricType {
		let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
		switch context.biometryType {
		case .none:
			return .none
		case .touchID:
			return .touchID
		case .faceID:
			return .faceID
		}
	}
	
	func authenticateUser(completion: @escaping (String?) -> Void) {
		guard canEvaluatePolicy() else {
			completion("Touch ID not available")
			return
		}
		
		context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, evaluateError) in
			if success {
				DispatchQueue.main.async {
					completion(nil)
				}
			} else {
				let message: String
				
				switch evaluateError {
				case LAError.authenticationFailed?:
					message = "There was a problem verifying your identity"
				case LAError.userCancel?:
					message = "You pressed cancel"
				case LAError.userFallback?:
					message = "You pressed password"
				case LAError.biometryNotAvailable?:
					message = "Face/Touch ID unavailable"
				case LAError.biometryNotEnrolled?:
					message = "Face/Touch ID not setup"
				case LAError.biometryLockout?:
					message = "Face/Touch ID is locked"
				default:
					message = "There was an error with Face/Touch ID"
				}
				
				completion(message)
			}
		}
	}
}
