//
//  SwipeUpCollectionControllerCollectionViewController.swift
//  SwipeUp
//
//  Created by Robert Otani on 6/5/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit

let reuseIdentifier = "SwipeUpCollectionCellID"

class SwipeUpCollectionControllerCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SwipeUpCell
        cell.configure()
        // Configure the cell
    
        return cell
    }

}
