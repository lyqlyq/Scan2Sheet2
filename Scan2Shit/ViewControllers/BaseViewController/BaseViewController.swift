//
//  BaseViewController.swift
//  iMusic
//
//  Created by Cuong on 8/14/17.
//  Copyright © 2017 HCM. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // custom title view
        let titleView = UIImageView(image: UIImage(named: "title_bar"))
        titleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
}
