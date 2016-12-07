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
        self.alpha = 0.2
        isUserInteractionEnabled = false
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
        
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleDetailTap(_:)))
                theCardDetailView.addGestureRecognizer(tap)
        
    }
    
    func handleDetailTap(_ sender: UIGestureRecognizer) {
        print("the bottom area just got tappppped")
    }
    
    func isPanning(pan: UIPanGestureRecognizer) {
        
        
        if let cardPan = pan as? CardPanGestureRecognizer {
            
            
//            if pan.state == .ended && theCardDetailView.isAtMinimumSize {
//                cardPan.shouldPanDownwards = false
//            }
            let pointOfTouch = pan.location(in: self)
            animateDetailView(pointOfTouch: pointOfTouch)
        }
    }
    
    func animateDetailView(pointOfTouch: CGPoint) {
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
            })
    }

}
