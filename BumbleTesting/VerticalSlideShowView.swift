//
//  VerticalSlideShowView.swift
//  BumbleTesting
//
//  Created by Daniel Jones on 12/5/16.
//  Copyright © 2016 Daniel Jones. All rights reserved.
//

import UIKit

//rename to VerticalSlideView
class VerticalSlideShowView: UIView {
    fileprivate enum Direction {
        case down
        case up
        case zero
    }
    
    fileprivate var scrollDirection: Direction = .zero
    var theBumbleScrollView: BumbleScrollView!
    var theCardDetailView: CardDetailView!
    var theCardDetailBackgroundHolderView: CardDetailBackgroundHolderView!
    
    init(imageFiles: [Any], frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
        scrollViewSetup(imageFiles: imageFiles)
        infoHolderViewSetup()
        
        let pan = CardPanGestureRecognizer(target: self, action: #selector(self.isPanning(pan:)))
        pan.delegate = self
        pan.cardPanDelegate = self
        //        self.isUserInteractionEnabled = false
        self.addGestureRecognizer(pan)
        
        theBumbleScrollView.panGestureRecognizer.require(toFail: pan)

    }
    
    func isPanning(pan: UIPanGestureRecognizer) {
        if let cardPan = pan as? CardPanGestureRecognizer {
            let pointOfTouch = pan.location(in: self)
            theCardDetailBackgroundHolderView.animateDetailView(pointOfTouch: pointOfTouch)
        
            
//            if pan.state == .ended && theCardDetailView.isAtMinimumSize {
//                cardPan.shouldPanDownwards = false
//            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func infoHolderViewSetup() {
        theCardDetailBackgroundHolderView = CardDetailBackgroundHolderView(frame: self.bounds)
        theCardDetailView = theCardDetailBackgroundHolderView.theCardDetailView
        self.addSubview(theCardDetailBackgroundHolderView)
    }
    
    fileprivate func scrollViewSetup(imageFiles: [Any]) {
        theBumbleScrollView = BumbleScrollView(imageFiles: imageFiles, delegate: self, frame: self.bounds)
        theBumbleScrollView.delegate = self
        self.addSubview(theBumbleScrollView)
    }
}

extension VerticalSlideShowView: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollDirection == .zero {
            theBumbleScrollView.finishScrollToProperPage()
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        switch scrollDirection {
        case .down:
            theBumbleScrollView.scrollToFollowingPage()
        case .up:
            theBumbleScrollView.scrollToPreviousPage()
        default:
            break
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            scrollDirection = .down
        } else if velocity.y < 0 {
            scrollDirection = .up
        } else if velocity.y == 0 {
            scrollDirection = .zero
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        theBumbleScrollView.beginningContentOffsetPriorToSwipe = scrollView.contentOffset
    }
}

extension VerticalSlideShowView: UIGestureRecognizerDelegate, CardPanGestureDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if theBumbleScrollView.isAtFinalPage || isCardOpen() {
            return true
        } else {
            return false
        }
    }
    
    func isCardOpen() -> Bool {
        return !theCardDetailView.isAtMinimumSize
    }
}


