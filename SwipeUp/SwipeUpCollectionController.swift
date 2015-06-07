//
//  SwipeUpCollectionControllerCollectionViewController.swift
//  SwipeUp
//
//  Created by Robert Otani on 6/5/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit

class SwipeUpCollectionController: UICollectionViewController, SwipeUpCellDelegate {

    var items: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items!.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SwipeUpCell.cellID(), forIndexPath: indexPath) as! SwipeUpCell
        let tagNumber = items![indexPath.item] as! NSNumber
        cell.configure(self, tag: tagNumber)
        // Configure the cell
    
        return cell
    }
    
    private func reset() {
        items = NSMutableArray(array: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    }
    
    // MARK: SwipeUpCellDelegate
    
    func swipeUpDidFinish(tag: NSNumber) {
        let lock = dispatch_queue_create("com.otanistudio.SwipeUp.lockQueue", nil)
        dispatch_sync(lock, { () -> Void in
            let indexToRemove = self.items!.indexOfObject(tag)
            let indexPathToRemove = NSIndexPath(forItem: indexToRemove, inSection: 0)
            self.items!.removeObjectAtIndex(indexToRemove)
            self.collectionView!.deleteItemsAtIndexPaths([indexPathToRemove])
            
            if (self.items!.count == 0) {
                self.reset()
                self.collectionView!.reloadData()
            }
        })
    }

}
