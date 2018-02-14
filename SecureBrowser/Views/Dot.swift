//
//  Dot.swift
//  SecureBrowser
//
//  Created by Cameron Smith on 2/12/18.
//  Copyright © 2018 Flying Moose Development. All rights reserved.
//

import UIKit
@IBDesignable

class Dot: UIView {
	@IBInspectable let fillColor:UIColor = UIColor.white
	@IBInspectable let borderColor:UIColor = UIColor.white
	@IBInspectable let borderThickness:CGFloat = CGFloat(2.0)

	@IBInspectable var isSelected:Bool = false {
		didSet {
			handleSelection()
			setNeedsDisplay()
		}
	}
	
	var path:UIBezierPath?

	override func draw(_ rect: CGRect) {
		let circleBase = CGRect(x: frame.size.width/2 - frame.size.height/2, y: 0.0, width: frame.size.height, height: frame.size.height)
		
		path = UIBezierPath(ovalIn: circleBase.insetBy(dx: borderThickness, dy: borderThickness))
		path?.lineWidth = borderThickness
		
		borderColor.setStroke()
		path?.stroke()
		
		handleSelection()
	}
	
	private func handleSelection() {
		if isSelected {
			fillColor.setFill()
			path?.fill()
		}
	}
}
