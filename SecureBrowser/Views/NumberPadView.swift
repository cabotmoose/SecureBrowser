//
//  NumberPadView.swift
//  SecureBrowser
//
//  Created by Cameron Smith on 2/12/18.
//  Copyright © 2018 Flying Moose Development. All rights reserved.
//

import UIKit

protocol NumberPadViewDelegate: class {
	func didPressNumber(number:Int)
}

class NumberPadView: UIView {
	var delegate:NumberPadViewDelegate?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	init(frame:CGRect, delegate: NumberPadViewDelegate) {
		self.delegate = delegate
		super.init(frame: frame)
	}
	
	override func draw(_ rect: CGRect) {
		let rowHeight = bounds.size.height / 4
		let rowWidth = bounds.size.width
		
		let firstRowRect = CGRect(x: 0, y: 0, width: rowWidth, height: rowHeight)
		let secondRowRect = CGRect(x: 0, y: rowHeight, width: rowWidth, height: rowHeight)
		let thirdRowRect = CGRect(x: 0, y: CGFloat(rowHeight * 2), width: rowWidth, height: rowHeight)
		let fourthRowRect = CGRect(x: 0, y: CGFloat(rowHeight * 3), width: rowWidth, height: rowHeight)
		
		let firstRowNumbers = [1,2,3]
		let secondRowNumbers = [4,5,6]
		let thirdRowNumbers = [7,8,9]
		let fouthRowNumbers = [0]
		
		drawRow(rect: firstRowRect, numbers: firstRowNumbers)
		drawRow(rect: secondRowRect, numbers: secondRowNumbers)
		drawRow(rect: thirdRowRect, numbers: thirdRowNumbers)
		drawRow(rect: fourthRowRect, numbers: fouthRowNumbers)
	}
	
	func drawRow(rect:CGRect, numbers:[Int]) {
		for i in 0..<numbers.count {
			let thisRect = CGRect(x: i*(Int(rect.size.width)/numbers.count), y: Int(rect.origin.y), width: Int(rect.size.width)/numbers.count, height: Int(rect.size.height)).insetBy(dx: 20, dy: 20)
			let thisButton = NumberButton(frame: thisRect, number: numbers[i])
			thisButton.addTarget(self, action: #selector(NumberPadView.buttonPressed(sender:)), for: .touchUpInside)
			addSubview(thisButton)
		}
	}
	
	@objc func buttonPressed(sender:NumberButton) {
		if let number = sender.number {
			delegate?.didPressNumber(number: number)
		}
	}
}

