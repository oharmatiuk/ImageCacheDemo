
//
//  AHImageMask.swift
//  ImageCacheDemo
//
//  Created by Oleksandr Harmatiuk on 5/19/17.
//  Copyright © 2017 AH. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics

let kMaskInset: CGFloat = 10.0
let kMaskCornerRadius: CGFloat = 20.0

enum MaskType {
	case roundedRect
	case circle
	case rect
}

class AHImageMask: UIImage {
	public var maskPath: CGPath?
	
	init(type:MaskType, size:CGSize) {
		UIGraphicsBeginImageContext(size)
		
		let context = UIGraphicsGetCurrentContext()
		
		context?.setFillColor(UIColor.white.cgColor)
		
		// Draw white background image
		let backgroundRect = CGRect(origin: CGPoint.zero, size: size)
		let backgroundPath = UIBezierPath(rect: backgroundRect).cgPath
		
		context?.addPath(backgroundPath)
		context?.closePath()
		context?.fillPath()
		
		// Draw internal black image
		let insets = UIEdgeInsetsMake(kMaskInset, kMaskInset, kMaskInset, kMaskInset)
		
		let maskRect = UIEdgeInsetsInsetRect(backgroundRect, insets)
		
		let cornerRadius:CGFloat
        
		switch(type) {
            case .rect:
                cornerRadius = 0
            case .roundedRect:
                cornerRadius = kMaskCornerRadius
            case .circle:
                cornerRadius = maskRect.width / 2
		}
		
		let maskPath = UIBezierPath(roundedRect: maskRect, cornerRadius: cornerRadius).cgPath
		
		context?.setFillColor(UIColor.black.cgColor)
		context?.addPath(maskPath)
		context?.closePath()
		context?.fillPath()
		
		
		let maskImage = UIGraphicsGetImageFromCurrentImageContext()!
		
		UIGraphicsEndImageContext()
		
		super.init(cgImage: maskImage.cgImage!)
		self.maskPath = maskPath
	}
	
	override init(cgImage: CGImage, scale: CGFloat, orientation: UIImageOrientation) {
		super.init(cgImage: cgImage, scale: scale, orientation: orientation)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	required convenience init(imageLiteralResourceName name: String) {
		fatalError("init(imageLiteralResourceName:) has not been implemented")
	}

}
