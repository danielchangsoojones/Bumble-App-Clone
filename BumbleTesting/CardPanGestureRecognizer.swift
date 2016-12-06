//
//  CardPanGestureRecognizer.swift
//  BumbleTesting
//
//  Created by Daniel Jones on 12/5/16.
//  Copyright © 2016 Daniel Jones. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class CardPanGestureRecognizer: UIPanGestureRecognizer {
    var shouldPanDownwards: Bool = false
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        let theVelocity : CGPoint = velocity(in: self.view!)
        if theVelocity.y > 0 && !shouldPanDownwards {
            //swiping downwards, but shouldn't be
            self.state = .failed
        } else if theVelocity.y < 0 {
            shouldPanDownwards = true
        }
    }
    
    var direction: UISwipeGestureRecognizerDirection? {
        get {
            let theVelocity : CGPoint = velocity(in: self.view!)
            if theVelocity.y > 0 {
                return .up
            } else if theVelocity.y < 0 {
                return .down
            }
            return nil
        }
    }
}
