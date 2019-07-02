//
//  LoginViewController.swift
//  Scan2Sheet
//
//  Created by cuongab on 4/24/19.
//  Copyright © 2019 HCM. All rights reserved.
//

import UIKit

class LoginViewController: PresentedViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBAction func loginAction(_ sender: Any) {
        errorLabel.isHidden = true
        
        GSheetService.shared.login(callback: { [weak self] (error) in
            if error != nil {
                self?.errorLabel.text = error?.localizedDescription
                self?.errorLabel.isHidden = false
            }
            else {
                self?.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.textColor = ColorCfg.color_8
        titleLabel.font = FontCfg.font_8
        
        errorLabel.textColor = ColorCfg.color_10
        errorLabel.font = FontCfg.font_10
        errorLabel.isHidden = true
    }
}
