//
//  AHImageDownloadQueue.swift
//  ImageCacheDemo
//
//  Created by Oleksandr Harmatiuk on 5/19/17.
//  Copyright © 2017 AH. All rights reserved.
//

import Foundation

private let kOperationsLimit = 20
private let kTopPrioritiesOperationsCount = 10

class AHImageDownloadQueue: OperationQueue {
	override init(){
		super.init()
		self.maxConcurrentOperationCount = kTopPrioritiesOperationsCount
	}
	
	override func addOperation(_ op: Operation) {
		self.cancelObsoleteOperations()
		self.lowerPriorities()
		super.addOperation(op)
		
		print("[DEBUG]: Operations count: \(self.operations.count)")
	}
	
	func cancelObsoleteOperations() {
		if (self.operations.count > kOperationsLimit) {
			let endIndex = self.operations.endIndex.advanced(by: -kOperationsLimit)
			let operationsToCancel = Array(self.operations[0...endIndex])
			for operation in operationsToCancel.reversed() {
				if operation.isCancelled {
					// we are going backward from active operations to the oldest ones
					// so let's break as soon as cancelled operation occurs. no need to cancel it once more
					break
				}
				operation.cancel()
			}
		}
	}
	
	func lowerPriorities() {
		/*
			The idea is to keep downloading and caching images for already invisible cells, but with lower priority
			Last operation is always with high priority
			This method performs lowering priorities for other operations.
			However this step can be improved: Operations do not always start with correct order
		*/
		if (self.operations.count > kTopPrioritiesOperationsCount) {
			let endIndex = self.operations.endIndex.advanced(by: -kTopPrioritiesOperationsCount)
			let operationsToUpdate = Array(self.operations[0...endIndex])
			for operation in operationsToUpdate.reversed() {
				if operation.isCancelled {
					// same here - no need to lower priority of cancelled operation
					break
				}
				operation.queuePriority = .normal
			}
		}
	}
}
