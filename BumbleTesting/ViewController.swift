//
//  ViewController.swift
//  BumbleTesting
//
//  Created by Daniel Jones on 12/5/16.
//  Copyright © 2016 Daniel Jones. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        verticalSlideShowViewSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func verticalSlideShowViewSetup() {
        let vertSlideView = VerticalSlideShowView(imageFiles: [#imageLiteral(resourceName: "unsplashGirl140"), #imageLiteral(resourceName: "usagirl"), #imageLiteral(resourceName: "windowGirl")], frame: self.view.bounds)
        self.view.addSubview(vertSlideView)
    }
}

