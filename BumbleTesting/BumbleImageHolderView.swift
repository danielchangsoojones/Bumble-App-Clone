//
//  BumbleImageHolderView.swift
//  BumbleTesting
//
//  Created by Daniel Jones on 12/5/16.
//  Copyright © 2016 Daniel Jones. All rights reserved.
//

import UIKit
import SnapKit

class BumbleImageHolderView: UIView {
    var theImageView: UIImageView!
    
    init(image: UIImage, frame: CGRect) {
        super.init(frame: frame)
        imageViewSetup(image: image)
    }
    
    private func imageViewSetup(image: UIImage) {
        theImageView = UIImageView(image: image)
        self.addSubview(theImageView)
        theImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }

}
