//
//  UIImage+Mask.swift
//  ImageCacheDemo
//
//  Created by oharmatiuk on 5/19/17.
//  Copyright © 2017 AH. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

// TODO: Perform refactoring
extension UIImage {
	func maskedWith(_ maskType:MaskType) -> UIImage {
		
		// TODO: keep masks as singletons in case of performance issues
		let maskImage = AHImageMask(type: maskType, size: self.size)
		let maskReference:CGImage = maskImage.cgImage!
		
		let imageReference = UIImage.addStroke(forImage: self, withMask: maskImage).cgImage!
		
		let imageMask = CGImage(maskWidth: maskReference.width,
		                        height: maskReference.height,
		                        bitsPerComponent: maskReference.bitsPerComponent,
		                        bitsPerPixel: maskReference.bitsPerPixel,
		                        bytesPerRow: maskReference.bytesPerRow,
		                        provider: maskReference.dataProvider!,
		                        decode: nil,
		                        shouldInterpolate: true)
		
		let maskedReference = imageReference.masking(imageMask!)
		let maskedImage = UIImage(cgImage: maskedReference!)
		return maskedImage
	}
	
	class func addStroke(forImage image:UIImage, withMask mask: AHImageMask) -> UIImage {
		let imageWithBorder: UIImage
		
		UIGraphicsBeginImageContext(image.size)
		
		let context = UIGraphicsGetCurrentContext()
		
		// Avoiding CGContext's upside down draw
		image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
		
		context?.setStrokeColor(UIColor.white.cgColor)
		context?.setLineWidth(10.0)
		context?.addPath(mask.maskPath!)
		context?.strokePath()
		
		imageWithBorder = UIGraphicsGetImageFromCurrentImageContext()!
		
		UIGraphicsEndImageContext()
		
		return imageWithBorder;
	}
	
}
