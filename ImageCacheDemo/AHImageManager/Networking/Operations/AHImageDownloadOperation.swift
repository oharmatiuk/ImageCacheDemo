//
//  AHImageDownloadOperation.swift
//  ImageCacheDemo
//
//  Created by Oleksandr Harmatiuk on 5/19/17.
//  Copyright © 2017 AH. All rights reserved.
//

import Foundation


class AHImageDownloadOperation: Operation {
    // Used semaphore locking, because urlSession async task has more comfortable handler: block with imageData
	// Maybe would be better to use synchronous task with delegates to avoid semaphore holding
	private let semaphore = DispatchSemaphore(value: 0)
    
	private var task:URLSessionTask?
	
	init(with request:URLRequest, completion: @escaping (_ imageData: Data?) -> ()) {
		super.init()
		self.queuePriority = .veryHigh
        
        let urlSession = AHRequestDispatcher.sharedInstance.session;
		task = urlSession.dataTask(with: request, completionHandler: { (imageData, _, error) in
			defer {
				self.releaseFlow()
			}
			print("[DEBUG]: Task completed")
			if error != nil {
				print("AHImageDownloadOperation: \(error!.localizedDescription)")
			} else {
				completion(imageData)
			}
		})
	}
	
	override func cancel() {
		self.task!.cancel()
		self.releaseFlow()
		super.cancel()
	}
	
	override func main() {
		if self.isCancelled {
			return
		}
		
		self.task!.resume()
		
		// To keep operation in queue untill async task is completed or cancelled
        // to be able to cancel operation
		self.holdFlow()
	}
	
	override func start() {
		super.start()
	}
	
	override var isAsynchronous: Bool {
		return true
	}
	
	override var isConcurrent: Bool {
		return true
	}
	
	func holdFlow() {
		self.semaphore.wait()
	}
	
	func releaseFlow() {
		self.semaphore.signal()
	}
	
}
