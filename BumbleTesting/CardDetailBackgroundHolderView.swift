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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.purple
        cardDetailSetup()
        addPanGesture()
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
    
    fileprivate func addPanGesture() {
        let pan = CardPanGestureRecognizer(target: self, action: #selector(self.isPanning(pan:)))
        self.addGestureRecognizer(pan)
        
//                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleDetailTap(_:)))
//                theCardDetailView.addGestureRecognizer(tap)
        
    }
    
//    func handleDetailTap(_ sender: UIGestureRecognizer) {
//        self.theCardDetailView.frame = CGRect(x: 0, y: 50, width: self.frame.width, height: 50)
//    }
    
    func isPanning(pan: UIPanGestureRecognizer) {
        if let cardPan = pan as? CardPanGestureRecognizer {
            if pan.state == .ended && theCardDetailView.isAtMinimumSize {
                cardPan.shouldPanDownwards = false
            }
            let pointOfTouch = pan.location(in: self)
            animateDetailView(direction: cardPan.direction, pointOfTouch: pointOfTouch)
            
        }
    }
    
    fileprivate func animateDetailView(direction: UISwipeGestureRecognizerDirection?, pointOfTouch: CGPoint) {
        if let direction = direction {
            let directionMultipler: CGFloat = direction == .up ? 1 : -1
            UIView.animate(withDuration: 0.3, animations: {
                let detailFrame = self.theCardDetailView.frame
                ///TODO: what if point of touch is > max height
                let heightDiffFromOriginalHeight = (pointOfTouch.y - self.theCardDetailView.originalFrame.height)
                let touchPercentOfMaxHeight = heightDiffFromOriginalHeight / self.theCardDetailView.maxFrame.height
                let newFrame = CGRect(x: detailFrame.minX, y: pointOfTouch.y, width: detailFrame.width, height: detailFrame.maxY - pointOfTouch.y)
//                let targetInset = touchPercentOfMaxHeight * self.theCardDetailView.insetDifference
                
                
                let inset = (touchPercentOfMaxHeight * self.theCardDetailView.insetDifference) * directionMultipler
                let insetFrame = newFrame.insetBy(dx: inset, dy: inset)
                self.theCardDetailView.frame = insetFrame
            })
        }
    }

}
