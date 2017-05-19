//
//  AHImageRequest.swift
//  ImageCacheDemo
//
//  Created by Oleksandr Harmatiuk on 5/19/17.
//  Copyright © 2017 AH. All rights reserved.
//

import Foundation

class AHImageRequest: NSURLRequest {
	init(width:Int, height: Int) {
		let imageURLString = kImageServiceURL + "/\(width)" + "/\(height)"
		let imageURL: URL = URL(string: imageURLString)!
		super.init(url: imageURL, cachePolicy: .returnCacheDataElseLoad , timeoutInterval: 60)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
