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
    override var tintColor: UIColor! {
        didSet {
            makeLastBubbleColor()
        }
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        pageCount = 5
        makeLastBubbleColor()
        
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
