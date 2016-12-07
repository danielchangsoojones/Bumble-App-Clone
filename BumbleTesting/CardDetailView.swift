//
//  CardDetailView.swift
//  BumbleTesting
//
//  Created by Daniel Jones on 12/5/16.
//  Copyright © 2016 Daniel Jones. All rights reserved.
//

import Foundation
import UIKit

class CardDetailView: UIView {    
    var insetDifference: CGFloat {
        get {
            return originalFrameInset - maxFrameInset
        }
    }
    var finishSwipeThresholdY: CGFloat {
        get {
            return maxFrame.maxY * 0.75
        }
    }
    var isOpen: Bool {
        get {
            return self.frame != originalFrame
        }
    }
    
    
    override var frame: CGRect {
        didSet {
            if frame.height <= originalFrame.height {
                super.frame = originalFrame
            } else if frame.height >= maxFrame.height {
                super.frame = maxFrame
            }
        }
    }
    
    let maxFrameInset: CGFloat = 1
    let originalFrameInset: CGFloat = 10
    var originalFrame: CGRect = CGRect.zero
    var maxFrame: CGRect = CGRect.infinite
    
    init(frameWidth: CGFloat, frameMinY: CGFloat, height: CGFloat) {
        let theFrame = CGRect(x: 0, y: frameMinY, width: frameWidth, height: height)
        let insetFrame = theFrame.insetBy(dx: originalFrameInset, dy: originalFrameInset)
        super.init(frame: insetFrame)
        originalFrame = insetFrame
    }
    
    func setMaxFrame() {
        if let superview = superview {
            let y = superview.frame.height * 0.25
            let aFrame = CGRect(x: 0, y: y, width: superview.frame.width, height: superview.frame.height - y)
            maxFrame = aFrame.insetBy(dx: maxFrameInset, dy: maxFrameInset)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
