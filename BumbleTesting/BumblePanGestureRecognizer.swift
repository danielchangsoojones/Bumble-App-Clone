//
//  BumblePanGestureRecognizer.swift
//  BumbleTesting
//
//  Created by Daniel Jones on 12/5/16.
//  Copyright © 2016 Daniel Jones. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class BumblePanGestureRecognizer: UIPanGestureRecognizer {
    var direction: UISwipeGestureRecognizerDirection? {
        get {
            let theVelocity : CGPoint = velocity(in: self.view!)
            if theVelocity.y < 0 {
                return .up
            } else if theVelocity.y > 0 {
                return .down
            }
            return nil
        }
    }
    var haveStartedCardOpenDrag: Bool = false
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if direction == .down && !haveStartedCardOpenDrag {
            self.state = .failed
        }
    }
}
