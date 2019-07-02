//
//  MenuViewController.swift
//  Scan2Sheet
//
//  Created by Macbook on 5/15/19.
//  Copyright © 2019 HCM. All rights reserved.
//

import UIKit
import MessageUI
import AlamofireImage

class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var importSwitch: UISwitch!
    @IBOutlet weak var scanSwitch: UISwitch!

    @IBAction func signOutAction(_ sender: Any) {
        GSheetService.shared.logout()
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "USER_SIGNOUT"), object: nil)
    }
    
    @IBAction func importAction(_ sender: UISwitch) {
        GSheetService.shared.isAutoSend = sender.isOn
    }
    
    @IBAction func scanAction(_ sender: UISwitch) {
        GSheetService.shared.isAutoScan = sender.isOn
    }
    
    @IBAction func rateAction(_ sender: Any) {
        let url = URL.init(string: REVIEW_URL)!
        UIApplication.shared.openURL(url)
    }
    
    @IBAction func feedbackAction(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = configuredMailComposeViewController()
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([SUPPORT_EMAIL])
        mailComposerVC.setSubject("[\(APP_NAME) \(APP_VERSION)] Request Support")
        
        mailComposerVC.setMessageBody("\n\n\nSupport For Device \(UIDevice.current.deviceType.displayName) - \(UIDevice.current.systemVersion)", isHTML: false)
        
        return mailComposerVC
    }
    
    
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [ SHARED_CONTENT ], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       setupDataView()
    }
    
    func setupDataView(){
        userNameLabel.text = GSheetService.shared.userName
        if let avatarURL = GSheetService.shared.avatar {
            userImageView.af_setImage(withURL: avatarURL)
        }
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = 29
        importSwitch.isOn = GSheetService.shared.isAutoSend
        scanSwitch.isOn = GSheetService.shared.isAutoScan

    }

}
