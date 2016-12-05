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
    
    init(imageFiles: [Any], frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
        scrollViewSetup(imageFiles: imageFiles)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView(color: UIColor, frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = color
        return view
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


