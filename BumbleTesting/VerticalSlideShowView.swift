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
    var theCardDetailView: CardDetailView!
    
    init(imageFiles: [Any], frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
        scrollViewSetup(imageFiles: imageFiles)
        infoHolderViewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func infoHolderViewSetup() {
        let infoHolderView = CardDetailBackgroundHolderView(frame: self.bounds)
        self.addSubview(infoHolderView)
    }
    
    fileprivate func cardDetailViewSetup() {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        view.backgroundColor = UIColor.green
        
        theCardDetailView.backgroundColor = UIColor.red
        view.addSubview(theCardDetailView)
        
        self.addSubview(view)
        
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


