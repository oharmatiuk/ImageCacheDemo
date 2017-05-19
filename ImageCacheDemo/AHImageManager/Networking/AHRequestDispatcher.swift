//
//  AHRequestDispatcher.swift
//  ImageCacheDemo
//
//  Created by Oleksandr Harmatiuk on 5/19/17.
//  Copyright © 2017 AH. All rights reserved.
//

import Foundation
import UIKit

let kImageServiceURL = "http://loremflickr.com"

class AHRequestDispatcher: NSObject {
	static let sharedInstance = AHRequestDispatcher()
    let session = URLSession(configuration: .ephemeral)
	var urlTasksQueue: AHImageDownloadQueue = AHImageDownloadQueue()
	
    override init() {
        super.init()
        self.session.configuration.httpMaximumConnectionsPerHost = 10
    }
    
	func downloadImage(completion: @escaping (_ image: UIImage?) -> ()) {
		let imageRequest = AHImageRequest(width: 100, height: 100) as URLRequest
		let imageDownloadOperation = AHImageDownloadOperation(with: imageRequest) { (receivedImageData) in
			guard let imageData = receivedImageData else {
				print("AHRequestDispather: received empty image data")
				completion(nil)
				return
			}
			let image = UIImage(data: imageData)
			completion(image)
		}
		urlTasksQueue.addOperation(imageDownloadOperation)
	}
}
