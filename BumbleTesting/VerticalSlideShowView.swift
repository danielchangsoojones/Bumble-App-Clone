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
    var theBumbleDetailView: BumbleDetailView!
    var theBumbleOverlayView: BumbleOverlayView!
    
    init(imageFiles: [Any], frame: CGRect) {
        super.init(frame: frame)
        scrollViewSetup(imageFiles: imageFiles)
        infoHolderViewSetup(numberOfPhotos: imageFiles.count)
        addPanGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func infoHolderViewSetup(numberOfPhotos: Int) {
        theBumbleOverlayView = BumbleOverlayView(frame: self.bounds, numberOfPhotos: numberOfPhotos)
        theBumbleDetailView = theBumbleOverlayView.theBumbleDetailView
        self.addSubview(theBumbleOverlayView)
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
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        theBumbleOverlayView.movePageControl(to: CGFloat(theBumbleScrollView.currentPage))
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

extension VerticalSlideShowView: UIGestureRecognizerDelegate {
    fileprivate func addPanGesture() {
        let bumblePan = BumblePanGestureRecognizer(target: self, action: #selector(self.isPanning(pan:)))
        bumblePan.delegate = self
        self.addGestureRecognizer(bumblePan)
        //One of the most important lines to make the Bumble scroll view work with the pan gesture on top of it. The scroll view pan gesture only starts receiving the touch, once this pan has failed, so in my subclass, I just tell it when to fail (based on direction, etc.). And when this failure occurs, then the scrollView is waiting to receive the touches instead. So, this pan gesture gets first rights to the touches, but if it fails then the scroll view gets to use the touches.
        theBumbleScrollView.panGestureRecognizer.require(toFail: bumblePan)
    }
    
    func isPanning(pan: UIPanGestureRecognizer) {
        let pointOfTouch = pan.location(in: self)
        
        if let cardPan = pan as? BumblePanGestureRecognizer {
            theBumbleOverlayView.pan(touchPoint: pointOfTouch, direction: cardPan.direction, state: pan.state)
            
            if pan.state == .ended || pan.state == .changed {
                cardPan.haveStartedCardOpenDrag = theBumbleDetailView.isOpen
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return theBumbleScrollView.isAtFinalPage || theBumbleDetailView.isOpen
    }
}


