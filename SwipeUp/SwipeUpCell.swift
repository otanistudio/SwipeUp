//
//  SwipeUpCell.swift
//  SwipeUp
//
//  Created by Robert Otani on 6/5/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit

protocol SwipeUpCellDelegate {
    func swipeUpDidFinish(tag: NSNumber)
}

class SwipeUpCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var panUpGestureRecognizer: UIPanGestureRecognizer!
    var delegate: SwipeUpCellDelegate!
    var itemTag: NSNumber!
    
    @IBOutlet weak var swipeableView: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        panUpGestureRecognizer = nil
        delegate = nil
        itemTag = nil
        tagLabel.text = ""
        swipeableView!.frame = contentView.frame
        swipeableView!.alpha = 1.0
    }
    
    class func cellID() -> String {
        return "SwipeUpCollectionCellID"
    }
    
    func configure(delegate: SwipeUpCellDelegate, tag: NSNumber) {
        panUpGestureRecognizer = UIPanGestureRecognizer(target: self, action: "didPanUp:");
        panUpGestureRecognizer?.delegate = self
        swipeableView!.image = UIImage(named: "derp.jpg")
        addGestureRecognizer(panUpGestureRecognizer!)
        self.delegate = delegate
        itemTag = tag
        tagLabel.text = tag.stringValue
    }
    
    internal func didPanUp(gesture: UIGestureRecognizer) {
        if (gesture == panUpGestureRecognizer
            && gesture.numberOfTouches() == 1
            && gesture.state == UIGestureRecognizerState.Changed) {
                contentView.clipsToBounds = false
                let location = gesture.locationInView(contentView);
                var frame = contentView.frame;
                frame.origin.y = location.y;
                if (frame.origin.y >= 0) {
                    frame.origin.y = 0;
                }
                swipeableView.frame = frame;
                let denom = contentView.bounds.size.height + fabs(location.y);
                let percent = contentView.bounds.size.height / denom;
                swipeableView.alpha = percent;
        } else if (gesture == panUpGestureRecognizer && gesture.state == UIGestureRecognizerState.Ended) {
            let swipableRect = swipeableView.frame;            
            let velocity = panUpGestureRecognizer.velocityInView(contentView)
            
            /*
                Naïve solution: If the bottom edge of the swipeableRect needs to cross
                the top of the bounding contentView and also needs to be
                fast enough for the swipe to work.
            */
            
            if ((-1.0 * swipableRect.origin.y < contentView.frame.size.height) && (velocity.y > -1500.0)) {
                UIView.animateWithDuration(0.5,
                    delay: 0,
                    usingSpringWithDamping: 0.33,
                    initialSpringVelocity: 0.0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: { [weak self]() -> Void in
                        self!.swipeableView.frame = self!.contentView.frame
                        self!.swipeableView.alpha = 1.0
                    }, completion: nil)
            } else {
                let fadeAwayLine = -1.0 * UIScreen.mainScreen().bounds.size.height / 1.5;
                
                UIView.animateWithDuration(
                    0.33,
                    delay: 0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: { [weak self]() -> Void in
                        self!.swipeableView.frame = CGRectMake(swipableRect.origin.x,
                            fadeAwayLine,
                            swipableRect.size.width,
                            swipableRect.size.height)
                        self!.swipeableView.alpha = 0.0
                    }, completion:{ [weak self](finished: Bool) -> Void in
                        self!.delegate.swipeUpDidFinish(self!.itemTag!)
                } )
                
            }
        }
    }
    
    // UIGestureRecognizerDelegate
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (!gestureRecognizer.isKindOfClass(UIPanGestureRecognizer.self)) {
            return false
        }
        let panRecognizer = gestureRecognizer as! UIPanGestureRecognizer
        let translation = panRecognizer.translationInView(contentView)
        return abs(translation.x) < abs(translation.y)
    }
}
