//
//  BumbleScrollView.swift
//  BumbleTesting
//
//  Created by Daniel Jones on 12/5/16.
//  Copyright © 2016 Daniel Jones. All rights reserved.
//

import UIKit

class BumbleScrollView: UIScrollView {
    fileprivate struct PageRange {
        var max: CGFloat = 0
        var min: CGFloat = 0
        
        var midPoint: CGFloat {
            get {
                return (max + min) / 2
            }
        }
        
        func contains(num: CGFloat) -> Bool {
            return max > num && min <= num
        }
    }
    
    fileprivate var pageRanges: [PageRange] = []
    var beginningContentOffsetPriorToSwipe: CGPoint = CGPoint.zero
    var isAtFinalPage: Bool {
        get {
            return pageRanges.last?.contains(num: contentOffset.y) ?? false
        }
    }
    
    init(imageFiles: [Any], delegate: UIScrollViewDelegate, frame: CGRect) {
        super.init(frame: frame)
        contentSize = CGSize(width: frame.width, height: 0)
        self.delegate = delegate
        showsVerticalScrollIndicator = false
        addImageHolders(imageFiles: imageFiles)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollToPreviousPage() {
        let tuple = getRanges()
        if let previousRange = tuple.previousRange {
            setContentOffsetFrom(pageRange: previousRange)
        }
    }
    
    func scrollToFollowingPage() {
        let tuple = getRanges()
        if let followingRange = tuple.followingRange {
            setContentOffsetFrom(pageRange: followingRange)
        }
    }
}

//adding views
extension BumbleScrollView {
    fileprivate func addImageHolders(imageFiles: [Any]) {
        var previousViewHeight: CGFloat = 0
        for file in imageFiles {
            if let image = file as? UIImage {
                let imageHolderView = BumbleImageHolderView(image: image, frame: CGRect(x: 0, y: previousViewHeight, width: self.frame.width, height: self.frame.height))
                addViewToScrollView(aView: imageHolderView)
                previousViewHeight += imageHolderView.frame.height
                pageRanges.append(PageRange(max: imageHolderView.frame.maxY, min: imageHolderView.frame.minY))
            }
        }
    }
    
    
    fileprivate func addViewToScrollView(aView: UIView) {
        self.addSubview(aView)
        self.contentSize.height += aView.frame.height
    }
}

extension BumbleScrollView {
    func finishScrollToProperPage() {
        let tuple = getRanges()
        if let currentRange = tuple.currentRange {
            if !shouldMoveToFollowingPage(currentRange: currentRange, followingRange: tuple.followingRange) && !shouldMoveToPreviousPage(currentRange: currentRange, previousRange: tuple.previousRange) {
                setContentOffsetFrom(pageRange: currentRange)
            }
        }
    }
    
    fileprivate func shouldMoveToFollowingPage(currentRange: PageRange, followingRange: PageRange?) -> Bool {
        if self.contentOffset.y >= currentRange.midPoint, let followingRange = followingRange {
            setContentOffsetFrom(pageRange: followingRange)
            return true
        }
        return false
    }
    
    fileprivate func shouldMoveToPreviousPage(currentRange: PageRange, previousRange: PageRange?) -> Bool {
        if let previousRange = previousRange, self.contentOffset.y <= previousRange.midPoint {
            setContentOffsetFrom(pageRange: previousRange)
            return true
        }
        return false
    }
    
    fileprivate func setContentOffsetFrom(pageRange: PageRange) {
        setContentOffset(CGPoint(x: 0, y: pageRange.min), animated: true)
    }
    
    fileprivate func getRanges() -> (previousRange:PageRange?, currentRange: PageRange?, followingRange: PageRange?) {
        let currentHeightPosition = beginningContentOffsetPriorToSwipe.y
        let index = pageRanges.index { (pageRange: PageRange) -> Bool in
            return pageRange.contains(num: currentHeightPosition)
        }
        
        var previousRange: PageRange? = nil
        var currentRange: PageRange? = nil
        var followingRange: PageRange? = nil
        
        if let index = index {
            
            let previousIndex = pageRanges.index(before: index)
            if pageRanges.indices.contains(previousIndex) {
                previousRange = pageRanges[previousIndex]
            }
            currentRange = pageRanges[index]
            
            let followingIndex = pageRanges.index(after: index)
            if pageRanges.indices.contains(followingIndex) {
                followingRange = pageRanges[followingIndex]
            }
            
        }
        
        print("previous range \(previousRange)")
        print("current range \(currentRange)")
        print("following range \(followingRange)")
        return (previousRange, currentRange, followingRange)
    }
}
