//
//  GSheetService.swift
//  Scan2Sheet
//
//  Created by cuongab on 4/23/19.
//  Copyright © 2019 HCM. All rights reserved.
//

import Foundation

import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

typealias LoginCallback = (_ error: Error?) -> Void

class GSheetService: NSObject {
    static let shared = GSheetService()
    private var rootViewController = APP_DELEGATE.window!.rootViewController!
    private var loginCallback: LoginCallback?
    
    func start() {
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "498190063567-a0us11qpg8nam4tco109vmvapeih7lm0.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/spreadsheets")
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    private override init() {
        super.init()
    }

    lazy var userService: GTLRSheetsService = {
        let service = GTLRSheetsService()
        service.authorizer = GIDSignIn.sharedInstance().currentUser?.authentication.fetcherAuthorizer()
        service.shouldFetchNextPages = true
        service.isRetryEnabled = true
        return service
    }()
    
    lazy var defaultService: GTLRSheetsService = {
        let service = GTLRSheetsService()
        service.apiKey = "AIzaSyDnW6z622-lUTrMQLn9cyQc_-D5GBVZV4s"
        service.shouldFetchNextPages = false
        service.isRetryEnabled = true
        return service
    }()

    func login(callback: @escaping (LoginCallback)) {
        GIDSignIn.sharedInstance().signIn()
        loginCallback = callback
    }
    
    func logout() {
        GIDSignIn.sharedInstance().signOut()
    }

    var isAuthenticated: Bool {
        return GIDSignIn.sharedInstance().hasAuthInKeychain() ? true : false
    }
    
    var isAutoSend: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "IS_AUTO_SEND_KEY")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "IS_AUTO_SEND_KEY")
        }
    }
    var isAutoScan: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "IS_AUTO_SCAN_KEY")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "IS_AUTO_SCAN_KEY")
        }
    }
    var url: String? {
        get {
            return UserDefaults.standard.string(forKey: "URL_KEY")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "URL_KEY")
        }
    }
    var sheetID: String? {
        get {
            return UserDefaults.standard.string(forKey: "SHEET_ID_KEY")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SHEET_ID_KEY")
        }
    }
    var userName: String?
    var avatar: URL?
    func extractSpreadsheetId() -> String? {
        guard let url = self.url else {
            return nil
        }
        
        guard let startRange = url.range(of: "/d/") else {
            return nil
        }
        guard let endRange = url.range(of: "/edit") else {
            let subString = url[startRange.upperBound ..< url.endIndex]
            return String(subString)
        }
        let subString = url[startRange.upperBound ..< endRange.lowerBound]
        return String(subString)
    }
}


extension GSheetService: GIDSignInDelegate, GIDSignInUIDelegate {
    // MARK: - GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            DLOG(error.localizedDescription)
            loginCallback?(error)
        }
        else {
            // when done signIn , value of `GIDSignIn.sharedInstance().currentUser` is not nil
            self.userName = user.profile.name
            if user.profile.hasImage {
                self.avatar = user.profile.imageURL(withDimension: 60)
            }
            loginCallback?(nil)
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        DLOG(error.localizedDescription)
    }

    // MARK: - GIDSignInUIDelegate
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {

    }

    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        rootViewController.present(viewController, animated: true, completion: nil)
    }

    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        rootViewController.dismiss(animated: true, completion: nil)
    }
}

extension GSheetService {
    func create(title: String, completionHandler: @escaping (_ error: Error?)-> Void ) {
        let sheet = GTLRSheets_Spreadsheet()
        sheet.properties = GTLRSheets_SpreadsheetProperties()
        sheet.properties?.title = title
        let query = GTLRSheetsQuery_SpreadsheetsCreate.query(withObject: sheet)
        userService.executeQuery(query) { [unowned self] (tk: GTLRServiceTicket, data: Any?, error: Error?) in
            if let error = error {
                DLOG(error.localizedDescription)
                completionHandler(error)
                return
            }
            
            let response = data as! GTLRSheets_Spreadsheet
            if let sheets = response.sheets {
                if sheets.count > 0 {
                    if let property = sheets[0].properties {
                        self.sheetID = property.title
                    }
                }
            }
            
            self.url = response.spreadsheetUrl
            completionHandler(nil)
        }
    }
    
    func update(title: String, forSheetID sheetID: String, completionHandler: @escaping (_ error: Error?)-> Void ) {
        
        let propertyRequest = GTLRSheets_UpdateSheetPropertiesRequest()
        propertyRequest.fields = "title"
        propertyRequest.properties = GTLRSheets_SheetProperties()
        propertyRequest.properties?.title = title
        
        let r = GTLRSheets_Request()
        r.updateSheetProperties = propertyRequest
        
        let request = GTLRSheets_BatchUpdateSpreadsheetRequest()
        request.requests = [r]
        
        let query = GTLRSheetsQuery_SpreadsheetsBatchUpdate.query(withObject: request, spreadsheetId: sheetID)
        userService.executeQuery(query) { (tk: GTLRServiceTicket, data: Any?, error: Error?) in
            if let error = error {
                DLOG(error.localizedDescription)
                completionHandler(error)
                return
            }
            
            // let response = data as! GTLRSheets_BatchUpdateSpreadsheetResponse
            completionHandler(nil)
        }
    }
    
    func add(text : String, completionHandler : @escaping (_ error: Error?) -> Void) {
        if let url = url, url.count == 0 {
            completionHandler(NSError(code: 1001, message: "Please, Setup URL first."))
            return
        }
        guard let spreadsheetId = self.extractSpreadsheetId() else {
            completionHandler(NSError(code: 1002, message: "Oops, Invalid URL."))
            return
        }
        var _sheetID = self.sheetID
        if _sheetID == nil {
            _sheetID = "Sheet1"
        }
        
        let range = "\(_sheetID!)!A1:A1"
        let valueRange = GTLRSheets_ValueRange()
        valueRange.range = "\(_sheetID!)!A1:A1"
        valueRange.values = [[text]]
        valueRange.majorDimension = "ROWS"
        
        let query = GTLRSheetsQuery_SpreadsheetsValuesAppend.query(withObject: valueRange, spreadsheetId:  spreadsheetId, range: range)
        query.valueInputOption = "USER_ENTERED"
        
        userService.executeQuery(query) { (tk: GTLRServiceTicket, data: Any?, error: Error?) in
            if let error = error {
                DLOG(error.localizedDescription)
                completionHandler(error)
                return
            }
            
            // let response = data as! GTLRSheets_AppendValuesResponse
            completionHandler(nil)
        }
    }    
}
