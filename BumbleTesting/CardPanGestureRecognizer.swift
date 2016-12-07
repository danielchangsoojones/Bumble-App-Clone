//
//  CardPanGestureRecognizer.swift
//  BumbleTesting
//
//  Created by Daniel Jones on 12/5/16.
//  Copyright © 2016 Daniel Jones. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

protocol CardPanGestureDelegate {
    func shouldOnlyPanUpwards() -> Bool
}

class CardPanGestureRecognizer: UIPanGestureRecognizer {
    var shouldFail: Bool = false
    var shouldOnlyPanUpwards: Bool = false
    var shouldPanDownwards: Bool = false
    
    var cardPanDelegate: CardPanGestureDelegate?
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if let cardPanDelegate = cardPanDelegate {
            if direction == .down && cardPanDelegate.shouldOnlyPanUpwards() {
                self.state = .failed
            }
        }
    }
    
    var direction: UISwipeGestureRecognizerDirection? {
        get {
            let theVelocity : CGPoint = velocity(in: self.view!)
            print(theVelocity)
            if theVelocity.y < 0 {
                return .up
            } else if theVelocity.y > 0 {
                return .down
            }
            return nil
        }
    }
}
