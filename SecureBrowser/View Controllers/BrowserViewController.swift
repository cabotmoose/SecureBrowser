//
//  BrowserViewController.swift
//  SecureBrowser
//
//  Created by Cameron Smith on 2/12/18.
//  Copyright © 2018 Flying Moose Development. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController {
	@IBOutlet weak var urlTextField: UITextField!
	@IBOutlet weak var webView: WKWebView!
	@IBOutlet weak var backArrow: UIButton!
	@IBOutlet weak var forwardArrow: UIButton!
	@IBOutlet weak var bottomView: UIView!
	@IBOutlet weak var javascriptButton: UIButton!
	
	private var isAuthenticated = false
	private var didReturnFromBackground = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Setup delegates
		urlTextField.delegate = self
		webView.navigationDelegate = self
		
		//Setup navigation arrow images
		backArrow.setImage(UIImage(named: "back-arrow-highlighted"), for: .highlighted)
		forwardArrow.setImage(UIImage(named: "forward-arrow-highlighted"), for: .highlighted)
		
		//Add border to bottom UIView
		bottomView.layer.borderColor = UIColor.darkGray.cgColor
		bottomView.layer.borderWidth = CGFloat(0.5)
		
		//Test hardcoded URL
		testBrowser()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	private func testBrowser() {
		urlTextField.text = "https://www.google.com"
		let url = URL(string: "https://www.google.com")
		let req = URLRequest(url: url!)
		webView.load(req)
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}
	
	private func loadURL() {
		guard let urlString = urlTextField.text, !urlString.isEmpty else {
			showErrorAlert(message: "Invalid URL")
			return
		}
		
		if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
			guard let url = URL(string:urlString) else {
				showErrorAlert(message: "Invalid URL")
				return
			}
			
			let req = URLRequest(url: url)
			webView.load(req)
			UIApplication.shared.isNetworkActivityIndicatorVisible = true
		} else {
			let revUrlString = "https://\(urlString)"
			guard let url = URL(string:revUrlString) else {
				showErrorAlert(message: "Invalid URL")
				return
			}
			
			let req = URLRequest(url: url)
			webView.load(req)
			UIApplication.shared.isNetworkActivityIndicatorVisible = true
		}
	}
	
	//MARK: Helper Methods
	private func showErrorAlert(message: String) {
		let alertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		let dismissAction = UIAlertAction(title: "Dismiss", style: .default)
		alertView.addAction(dismissAction)
		show(alertView, sender: self)
	}
	
	private func updateNavigationArrows() {
		if webView.canGoBack {
			backArrow.alpha = 1
			backArrow.isEnabled = true
		} else {
			backArrow.alpha = 0.7
			backArrow.isEnabled = false
		}
		
		if webView.canGoForward {
			forwardArrow.alpha = 1
			forwardArrow.isEnabled = true
		} else {
			forwardArrow.alpha = 0.7
			forwardArrow.isEnabled = false
		}
	}
	
	private func updateUrlTextColor() {
		guard let urlString = urlTextField.text else { return }
		if urlString.hasPrefix("http://") {
			let range = (urlString as NSString).range(of: "http://")
			let attributedText = NSMutableAttributedString(string: urlString)
			attributedText.addAttribute(.foregroundColor, value: UIColor.red, range: range)
			attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: range)
			urlTextField.attributedText = attributedText
		} else if urlString.hasPrefix("https://") {
			let range = (urlString as NSString).range(of: "https://")
			let attributedText = NSMutableAttributedString(string: urlString)
			attributedText.addAttribute(.foregroundColor, value: UIColor.green, range: range)
			attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: range)
			urlTextField.attributedText = attributedText
		}
	}
	
	//MARK: IBActions
	@IBAction func backArrowTapped(_ sender: UIButton) {
		if webView.canGoBack {
			webView.goBack()
		}
	}
	
	@IBAction func forwardArrowTapped(_ sender: UIButton) {
		if webView.canGoForward {
			webView.goForward()
		}
	}
	@IBAction func javascriptButtonTapped(_ sender: UIButton) {
		if webView.configuration.preferences.javaScriptEnabled {
			webView.configuration.preferences.javaScriptEnabled = false
			javascriptButton.setTitle("Turn JavaScript On", for: .normal)
		} else {
			webView.configuration.preferences.javaScriptEnabled = true
			javascriptButton.setTitle("Turn JavaScript Off", for: .normal)
		}
		webView.reload()
	}
}

//MARK: WKWebKit Delegate Methods
extension BrowserViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		urlTextField.text = webView.url?.absoluteString
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
		updateNavigationArrows()
		updateUrlTextColor()
	}
}


//MARK: UITextField Delegate Methods
extension BrowserViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		view.endEditing(true)
		return false
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		loadURL()
	}
}
