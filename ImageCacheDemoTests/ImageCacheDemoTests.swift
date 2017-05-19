//
//  ImageCacheDemoTests.swift
//  ImageCacheDemoTests
//
//  Created by oharmatiuk on 5/19/17.
//  Copyright © 2017 AH. All rights reserved.
//

import XCTest

class ImageCacheDemoTests: XCTestCase {
    private var image: UIImage?
    
    override func setUp() {
        super.setUp()
        let request = AHImageRequest(width: 50, height: 50)
        guard let imageData = try? Data(contentsOf: request.url!) else { return }
        self.image = UIImage(data: imageData)
    }
    
    func testImageDownload() {
        XCTAssert(self.image != nil, "Failed to get image data")
    }
    
    func testImageMask() {
        let maskedImage = self.image?.maskedWith(.roundedRect)
        XCTAssert(maskedImage != nil, "Failed to create image mask")
    }
    
    func testImageManagerDownload() {
        AHImageManager.sharedInstance.downloadImageFor(index: 0) { (image) in
            XCTAssert(image != nil, "Failed to download image with AHImageManager")
        }
    }
    
    func testImageManagerCache() {
        let imageIndex = 0
        AHImageManager.sharedInstance.downloadImageFor(index: imageIndex) { (image) in
            let cachedImage = AHImageManager.sharedInstance.cachedImageForIndex(index: imageIndex)
            XCTAssert(cachedImage != nil, "Failed to download image with AHImageManager")
        }
    }
    
    override func tearDown() {
        self.image = nil
        super.tearDown()
    }
}
