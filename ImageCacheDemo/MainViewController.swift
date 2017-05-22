//
//  ViewController.swift
//  ImageCacheDemo
//
//  Created by oharmatiuk on 5/19/17.
//  Copyright © 2017 AH. All rights reserved.
//

import UIKit

class ImageTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Image is masked, just to demonstrate usage of CoreGraphics
    let placeHolderImage = UIImage(named: "cellPlaceholder")?.maskedWith(.roundedRect)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10000;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "imageCell")
        cell.textLabel?.text = String(indexPath.row)
        cell.backgroundColor = UIColor.lightGray
        
        let cachedImage = AHImageManager.sharedInstance.cachedImageForIndex(index: indexPath.row)
        cell.imageView?.image =  cachedImage ?? self.placeHolderImage
        
        if cachedImage == nil {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
                // check if user is scrolling - if cell is not visible - do not even start image request
                // this actually improved if user is fast scrolling - avoiding hundreds of unused operations in queue
                if tableView.cellForRow(at: indexPath) != nil {
                    AHImageManager.sharedInstance.downloadImageFor(index: indexPath.row, completion: { (receivedImage) in
                        print("[DEBUG]: Updating cell for row #\(indexPath.row)")
                        print("[DEBUG]: ================================================")
                        if let cellToUpdate = tableView.cellForRow(at: indexPath) {
                            DispatchQueue.main.async {
                                cellToUpdate.imageView?.image = receivedImage ?? self.placeHolderImage
                            }
                        }
                    })
                }
            })
        }
        
        /* Perhaps it would be more effective to use
         
         cell.imageView?.mask = AHSomeKindOfMaskedView...
         
         because cell is reused, so mask would be applied only when cell is created
         Can consider this as possible improvement in case of performance issues
         */
        
        return cell
    }
    
}

