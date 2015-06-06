//
//  SwipeUpCell.swift
//  SwipeUp
//
//  Created by Robert Otani on 6/5/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit

class SwipeUpCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var panUpGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var swipeableView: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        panUpGestureRecognizer = nil
    }
    
    class func cellID() -> String {
        return "SwipeUpCollectionCellID"
    }
    
    func configure() {
        panUpGestureRecognizer = UIPanGestureRecognizer(target: self, action: "didPanUp:");
        panUpGestureRecognizer?.delegate = self
        swipeableView!.image = UIImage(named: "derp.jpg")
        self.addGestureRecognizer(panUpGestureRecognizer!)
    }
    
    internal func didPanUp(gesture: UIGestureRecognizer) {
//        println("SwipeUpCell: gesture: \(gesture)")
        
        if (gesture == panUpGestureRecognizer
            && gesture.numberOfTouches() == 1
            && gesture.state == UIGestureRecognizerState.Changed) {
                self.contentView.clipsToBounds = false
                let location = gesture.locationInView(self.contentView);
                var frame = self.contentView.frame;
                frame.origin.y = location.y;
                if (frame.origin.y >= 0) {
                    frame.origin.y = 0;
                }
                self.swipeableView.frame = frame;
                let denom = self.contentView.bounds.size.height + fabs(location.y);
                let percent = self.contentView.bounds.size.height / denom;
                self.swipeableView.alpha = percent;
        } else if (gesture == self.panUpGestureRecognizer && gesture.state == UIGestureRecognizerState.Ended) {
            let swipableRect = self.swipeableView.frame;
            
//            println("SwipeUpCell: swipableRect.origin.y: \(swipableRect.origin.y)");
//            println("SwipeUpCell: self.contentView.frame.size.height: \(self.contentView.frame.size.height)");
            
            let velocity = panUpGestureRecognizer.velocityInView(self.contentView)
//            println("SwipeUpCell velocity in view: \(velocity)");
            
            /*
                Naïve solution: If the bottom edge of the swipeableRect needs to cross
                the top of the bounding contentView and also needs to be
                fast enough for the swipe to work.
            */
            
            if ((-1.0 * swipableRect.origin.y < self.contentView.frame.size.height) && (velocity.y > -1500.0)) {
                UIView.animateWithDuration(0.5,
                    delay: 0,
                    usingSpringWithDamping: 0.42,
                    initialSpringVelocity: 0.0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: { () -> Void in
                        self.swipeableView.frame = self.contentView.frame
                        self.swipeableView.alpha = 1.0
                    }, completion: nil)
            } else {
                let fadeAwayLine = -1.0 * UIScreen.mainScreen().bounds.size.height / 1.5;
                
                UIView.animateWithDuration(
                    0.33,
                    delay: 0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: { () -> Void in
                        self.swipeableView.frame = CGRectMake(swipableRect.origin.x,
                            fadeAwayLine,
                            swipableRect.size.width,
                            swipableRect.size.height)
                        self.swipeableView.alpha = 0.0
                    }, completion:{ (finished: Bool) -> Void in
                        println("finished move and fade away")
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
