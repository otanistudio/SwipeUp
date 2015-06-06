//
//  SwipeUpCollectionControllerCollectionViewController.swift
//  SwipeUp
//
//  Created by Robert Otani on 6/5/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit

class SwipeUpCollectionController: UICollectionViewController, SwipeUpCellDelegate {

    var items = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SwipeUpCell.cellID(), forIndexPath: indexPath) as! SwipeUpCell
        cell.configure(self, tag: UInt(indexPath.item))
        // Configure the cell
    
        return cell
    }
    
    func swipeUpDidFinish(tag: UInt) {
        let indexPathToRemove = NSIndexPath(forItem: Int(tag), inSection: 0)
        items.removeAtIndex(Int(tag))
        collectionView?.deleteItemsAtIndexPaths([indexPathToRemove])
    }

}
