//
//  MainViewController.swift
//  MusicRadio
//
//  Created by Admin on 10/15/18.
//  Copyright © 2018 HCM. All rights reserved.
//

import UIKit
import BarcodeScanner
import SideMenu
import MBProgressHUD

class MainViewController: UIViewController {
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var sheetIDTextField: UITextField!
    @IBOutlet weak var scanResultTextField: UITextField!
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var lbNotification: UILabel!
    @IBOutlet weak var notificationHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var notificationView: UIView!    
    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var successImageView: UIImageView!

    var currentCode: String? {
        didSet {
            scanResultTextField.isEnabled = (currentCode != nil) ? true : false
        }
    }
    
    @IBAction func importAction(_ sender: Any) {
        self.send()
    }
    
    @IBAction func menuAction(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func newSpreadsheetAction(_ sender: Any) {
        let newSpreadsheetVC = NewSpreadSheetViewController(nibName: NewSpreadSheetViewController.className, bundle: nil)
        newSpreadsheetVC.preferredContentSize = CGSize(width: 280, height: 200)
        newSpreadsheetVC.createActionCallback = {[unowned self]  in
            self.urlTextField.text = GSheetService.shared.url
            self.sheetIDTextField.text = GSheetService.shared.sheetID
        }
        self.present(newSpreadsheetVC, animated: true, completion: nil)
        
    }
    
    @IBAction func shareAction(_ sender: Any) {
        guard let url = GSheetService.shared.url else {
            return
        }
        if url.count == 0 {
            return
        }        
        
        let fileURL = URL(string: url)
        
        let objectsToShare = [fileURL]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    let cameraViewController = BarcodeScannerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSlideMenu()
        lbNotification.font = FontCfg.font_10
        notificationHeightConstraint.constant = 0
        successImageView.isHidden = true
        notificationImageView.isHidden = true
        
        urlTextField.font = FontCfg.font_5
        urlTextField.delegate = self
        urlTextField.text = GSheetService.shared.url
        
        
        sheetIDTextField.font = FontCfg.font_5
        sheetIDTextField.delegate = self
        sheetIDTextField.text = GSheetService.shared.sheetID
        
        scanResultTextField.textColor = ColorCfg.color_6
        scanResultTextField.font = FontCfg.font_6
        
        self.hideKeyboardWhenTappedAround()
        
        cameraViewController.codeDelegate = self
        cameraViewController.errorDelegate = self
        cameraViewController.dismissalDelegate = self
        
        add(viewController: cameraViewController, toView: cameraView)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapToCameraAction))
        cameraView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogoutAction(_:)), name: NSNotification.Name("USER_SIGNOUT"), object: nil)
    }
    
    @objc func handleLogoutAction(_ sender: Notification) {
        self.checkUserLogin()
    }
    
    func setupSlideMenu() {
        self.navigationController?.navigationBar.isHidden = true
        let menuVC = MenuViewController.init(nibName: MenuViewController.className, bundle: nil)
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: menuVC)
      
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
    
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.navigationBar, forMenu: .left)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view, forMenu: .left)
        
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuWidth = 3/4 * Device.SCREEN_WIDTH

    }
    
    func checkUserLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !GSheetService.shared.isAuthenticated {
                self.showLoginViewController()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        // Checking for userLogin
        self.checkUserLogin()
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == urlTextField {
            GSheetService.shared.url = textField.text
        }
        else if textField == sheetIDTextField {
            GSheetService.shared.sheetID = textField.text
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension MainViewController {
    @objc func tapToCameraAction() {
        // check autoScan
        print("Did touch to Camera Screen.")
        if !GSheetService.shared.isAutoScan && GSheetService.shared.isAuthenticated {
            self.cameraViewController.reset(animated: true)
        }
    }
    
    func showLoginViewController() {
        let loginViewController = LoginViewController(nibName: LoginViewController.className, bundle: nil)
        loginViewController.preferredContentSize = CGSize(width: 300, height: 300)
        self.present(loginViewController, animated: true, completion: nil)
    }
    func send() {
        guard let url = GSheetService.shared.url else {
            showErrorMessage("Enter URL or Create Spreedsheet first!")
            return
        }
        if url.count == 0 {
            showErrorMessage("Enter URL or Create Spreedsheet first!")
            return
        }
        
        guard let currentCode = currentCode else {
            return
        }
        GSheetService.shared.add(text: currentCode) {[unowned self] (error) in
            if let err = error {
                self.showErrorMessage(err.localizedDescription)
            }
            else {
                // clear currentCode
                self.currentCode = nil
                self.successImageView.isHidden = false
                // Show success
                self.showSuccessMessage()
                // continue scan
                if GSheetService.shared.isAutoScan {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.cameraViewController.reset(animated: true)
                    }
                }
            }
        }
    }
    
    func showSuccessMessage() {
        lbNotification.text = "Sent to Spreadsheet!"
        lbNotification.textColor = ColorCfg.color_10
        notificationImageView.isHidden = false
        notificationView.backgroundColor = ColorCfg.color_8
        
        self.showNotificationView()
    }
    func showErrorMessage(_ message: String) {
        lbNotification.text = message
        lbNotification.textColor = ColorCfg.color_10
        notificationImageView.isHidden = true
        notificationView.backgroundColor = UIColor.red.adjust(by: 0.7)
        
        self.showNotificationView()
    }
    
    func showNotificationView() {
        notificationHeightConstraint.constant = 40
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.notificationHeightConstraint.constant = 0
            self.notificationImageView.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
}
extension MainViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        currentCode = code
        scanResultTextField.text = currentCode
        self.successImageView.isHidden = true
        if GSheetService.shared.isAutoSend {
            self.send()
        }
    }
}

extension MainViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        self.showErrorMessage(error.localizedDescription)
    }
}

extension MainViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        // Nothing
    }
}
