//
//  NumberKey.swift
//  SecureBrowser
//
//  Created by Cameron Smith on 2/12/18.
//  Copyright © 2018 Flying Moose Development. All rights reserved.
//

import UIKit

class NumberButton:UIButton {
	var number:Int?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	init(frame:CGRect, number:Int) {
		self.number = number
		super.init(frame: frame)
		prepareLayout()
	}
	
	
	func prepareLayout() {
		let circleBase = CGRect(x: bounds.size.width/2 - bounds.size.height/2, y: bounds.origin.y, width: bounds.size.height, height: bounds.size.height)
		
		backgroundColor = UIColor.clear
		let circleLayer = CAShapeLayer()
		circleLayer.lineWidth = 2
		circleLayer.fillColor = UIColor.clear.cgColor
		circleLayer.path = UIBezierPath(ovalIn: circleBase.insetBy(dx: 2, dy: 2)).cgPath
		circleLayer.strokeColor = UIColor.white.cgColor
		circleLayer.contentsScale = UIScreen.main.scale
		circleLayer.shouldRasterize = false
		layer.addSublayer(circleLayer)
		
		let textLayer = CATextLayer()
		textLayer.string = "\(self.number ?? 1)"
		textLayer.foregroundColor = UIColor.white.cgColor
		textLayer.alignmentMode = kCAAlignmentCenter
		textLayer.contentsScale = UIScreen.main.scale
		textLayer.fontSize = 65
		textLayer.frame = layer.bounds
		circleLayer.addSublayer(textLayer)
	}
}
