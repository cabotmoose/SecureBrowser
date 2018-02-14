//
//  DotRow.swift
//  SecureBrowser
//
//  Created by Cameron Smith on 2/12/18.
//  Copyright © 2018 Flying Moose Development. All rights reserved.
//

import UIKit

class DotRow: UIView {
	let numberOfDots:Int
	var dotArray:[Dot] = []
	
	init(frame: CGRect, numberOfDots:Int = 4) {
		self.numberOfDots = numberOfDots
		super.init(frame: frame)
		setupDots(rect: frame)
	}
	
	override init(frame: CGRect) {
		self.numberOfDots = 4
		super.init(frame: frame)
		setupDots(rect: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.numberOfDots = 4
		super.init(coder: aDecoder)
		setupDots(rect: bounds)
	}
	
	func setupDots(rect: CGRect) {
		for i in 0..<numberOfDots {
			let thisDot = Dot(frame: CGRect(x: i*(Int(rect.size.width)/numberOfDots), y: 0, width: Int(rect.size.width)/4, height: Int(rect.size.height)))
			dotArray.append(thisDot)
			thisDot.backgroundColor = UIColor.clear
			addSubview(thisDot)
		}
	}
	
	func selectDot(at row:Int) {
		dotArray[row - 1].isSelected = true
	}
	
	func clearDots() {
		dotArray.forEach { dot in
			dot.isSelected = false
		}
	}
}
