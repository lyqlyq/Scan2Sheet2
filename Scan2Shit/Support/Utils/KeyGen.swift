//
//  KeyGen.swift
//  VlcSoundCloud
//
//  Created by Cuong on 9/18/17.
//  Copyright © 2017 HCM. All rights reserved.
//

import UIKit

class KeyGen: NSObject {
    static var arrKeys = [String]()
    
    static func getKey() -> String {
        if arrKeys.count == 0 {
            if let strKeys = UserDefaults.standard.string(forKey: "keygen") {
                arrKeys = strKeys.components(separatedBy: ",")
            }
            else {
                arrKeys = ["AIzaSyDnW6z622-lUTrMQLn9cyQc_-D5GBVZV4s"]
            }
        }
        
        let bound = arrKeys.count
        let index = arc4random_uniform(UInt32(bound))
        return arrKeys[Int(index)]
    }
    
    static func setKeys(_ strKeys: String) {
        arrKeys = strKeys.components(separatedBy: ",")
        UserDefaults.standard.set(strKeys, forKey: "keygen")
        UserDefaults.standard.synchronize()
    }
}
