//
//  CardDetailBackgroundHolderView.swift
//  BumbleTesting
//
//  Created by Daniel Jones on 12/5/16.
//  Copyright © 2016 Daniel Jones. All rights reserved.
//

import UIKit
import Cheetah

class CardDetailBackgroundHolderView: UIView {
    var theCardDetailView: CardDetailView!
    let minAlpha: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(minAlpha)
        //user interaction needs to be disabled because that is the only way we could pass touches to the scrollView below this background view
        isUserInteractionEnabled = false
        cardDetailSetup()
        addTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func cardDetailSetup() {
        theCardDetailView = CardDetailView(frameWidth: self.frame.width, frameMinY: self.bounds.maxY - 100, height: 100)
        theCardDetailView.backgroundColor = UIColor.red
        self.addSubview(theCardDetailView)
        theCardDetailView.setMaxFrame()
    }
    
    fileprivate func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleDetailTap(_:)))
        theCardDetailView.addGestureRecognizer(tap)
    }
    
    func handleDetailTap(_ sender: UIGestureRecognizer) {
        print("the bottom area just got tappppped")
    }
}

//handlind pan
extension CardDetailBackgroundHolderView {
    func pan(touchPoint: CGPoint, direction: UISwipeGestureRecognizerDirection?, state: UIGestureRecognizerState) {
        if state == .ended {
            if let direction = direction {
                finishSwipe(direction: direction)
            } else {
                finishNonVelocityDrag()
            }
        } else {
            animateDetailView(pointOfTouch: touchPoint)
        }
    }
    
    fileprivate func finishSwipe(direction: UISwipeGestureRecognizerDirection) {
        if direction == .up {
            animateToMaxFrame()
        } else if direction == .down {
            animateToOriginalFrame()
        }
    }
    
    fileprivate func finishNonVelocityDrag() {
        if theCardDetailView.frame.minY <= theCardDetailView.finishSwipeThresholdY {
            animateToMaxFrame()
        } else {
            animateToOriginalFrame()
        }
    }
    
    fileprivate func animateToMaxFrame() {
        animateDetailView(pointOfTouch: theCardDetailView.maxFrame.origin)
    }
    
    fileprivate func animateToOriginalFrame() {
        animateDetailView(pointOfTouch: theCardDetailView.originalFrame.origin)
    }
    
    fileprivate func animateDetailView(pointOfTouch: CGPoint) {
        UIView.animate(withDuration: 0.3, animations: {
            //open being when the cardDetail is showing its inner contents
            let openY = self.theCardDetailView.maxFrame.minY
            let closedY = self.theCardDetailView.originalFrame.minY
            let openInset = self.theCardDetailView.originalFrameInset
            let closedInset = self.theCardDetailView.maxFrameInset
            
            var currentTouchY = pointOfTouch.y
            if currentTouchY < openY {
                currentTouchY = openY
            } else if currentTouchY > closedY {
                currentTouchY = closedY
            }
            
            let percentOpened = (closedY - currentTouchY) / (closedY - openY)
            let inset = (1 - percentOpened) * (openInset - closedInset) + closedInset
            self.theCardDetailView.frame = CGRect(x: inset, y: currentTouchY, width: self.frame.maxX - inset * 2, height: self.frame.maxY - currentTouchY - inset)
            self.updateAlpha(percentOpened: percentOpened)
        })
    }
    
    fileprivate func updateAlpha(percentOpened: CGFloat) {
        let maxAlpha: CGFloat = 0.8
        let alphaDifference = maxAlpha - minAlpha
        let targetAlpha = (alphaDifference * percentOpened) + minAlpha
        self.backgroundColor = self.backgroundColor?.withAlphaComponent(targetAlpha)
    }
}
