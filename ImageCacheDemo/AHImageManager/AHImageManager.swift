//
//  AHImageManager.swift
//  ImageCacheDemo
//
//  Created by Oleksandr Harmatiuk on 5/19/17.
//  Copyright © 2017 AH. All rights reserved.
//

import Foundation
import UIKit

class AHImageManager {
	static let sharedInstance = AHImageManager()
	let imageCache: NSCache<AnyObject, AnyObject> = NSCache()
	
    func cachedImageForIndex(index:Int) -> (UIImage?) {
        return self.imageCache.object(forKey: NSNumber(value: index)) as? UIImage
    }
    
	// TODO: add error handler
	func downloadImageFor(index:Int, completion: @escaping (_ image:UIImage?) -> ()) {
        print("[DEBUG]: ------------------------------------------------")
        print("[DEBUG]: Downloading image for index: \(index)\n")
        AHRequestDispatcher.sharedInstance.downloadImage(completion: { (receivedImage) in
            guard let image = receivedImage else {
                completion(nil)
                return
            }
            let maskedImage = image.maskedWith(.roundedRect)
            self.imageCache.setObject(maskedImage, forKey: NSNumber(value: index))
            print("[DEBUG]: Cached image for index: \(index)")
            completion(maskedImage)
        })
    }
}
