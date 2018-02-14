//
//  CALayer.swift
//  SecureBrowser
//
//  Created by Cameron Smith on 2/12/18.
//  Copyright © 2018 Flying Moose Development. All rights reserved.
//

import UIKit

extension CALayer {
	
	func centerInSuperlayer() {
		guard let layer = superlayer else { return }
		position = CGPoint(x: layer.bounds.midX, y: layer.bounds.midY)
	}
}
