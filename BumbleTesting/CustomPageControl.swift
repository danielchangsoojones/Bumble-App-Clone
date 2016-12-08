//
//  CustomPageControl.swift
//  BumbleTesting
//
//  Created by Daniel Jones on 12/7/16.
//  Copyright © 2016 Daniel Jones. All rights reserved.
//

import Foundation
import UIKit

class CustomPageControl: FilledPageControl {
    override var pageCount: Int {
        didSet {
            makeLastBubbleColor()
        }
    }
    
    override var progress: CGFloat {
        didSet {
            previousProgress = oldValue
        }
    }
    
    var previousProgress: CGFloat = 0 {
        didSet (oldValue) {
            if previousProgress == progress {
                //when we are sliding the cardDetailView, don't let it slide and set the previous progress to itself because then it would go back to its own bubble when we dismiss it. This protects that. 
                previousProgress = oldValue
            }
        }
    }
    
    init(numberOfPages: Int) {
        super.init(frame: CGRect.zero)
        pageCount = numberOfPages
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeLastBubbleColor() {
        if let lastLayer = inactiveLayers.last {
            lastLayer.backgroundColor = UIColor.red.cgColor
        }
    }
}
