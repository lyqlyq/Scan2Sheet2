//
//  NewSpreadSheetViewController.swift
//  Scan2Sheet
//
//  Created by Macbook on 5/15/19.
//  Copyright © 2019 HCM. All rights reserved.
//

import UIKit
import MBProgressHUD

class NewSpreadSheetViewController: PresentedViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    var createActionCallback: (()->Void)?

    @IBAction func createAction(_ sender: Any) {
        
        if let sheetName = nameTextField.text, !sheetName.isEmpty {
            create(sheetName: sheetName)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.becomeFirstResponder()
        nameTextField.delegate = self
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)

    }
    
    func create(sheetName: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        GSheetService.shared.create(title: sheetName) { (error) in
            if let err = error {
                MBProgressHUD.hide(for: self.view, animated: false)
                self.showAlert(message: err.localizedDescription)
            }
            else {
                MBProgressHUD.hide(for: self.view, animated: false)
                self.dismiss(animated: true, completion: nil)
                self.createActionCallback?()
            }
        }
    }
}

extension NewSpreadSheetViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let sheetName = nameTextField.text, !sheetName.isEmpty {
            create(sheetName: sheetName)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
