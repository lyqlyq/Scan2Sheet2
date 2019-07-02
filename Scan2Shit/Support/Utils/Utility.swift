//
//  Utils.swift
//  iMusic
//
//  Created by Cuong on 8/16/17.
//  Copyright © 2017 HCM. All rights reserved.
//

import UIKit

// MARK: - PATHS
let HOME_PATH = NSHomeDirectory()
let DOCUMENTS_PATH = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
let LIBRARY_PATH = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
let LIBRARY_CACHES_PATH = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

func DLOG(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    print(items, separator: separator, terminator: terminator)
    #endif
}

func printError(_ string: String, file: String = #file, function: String = #function, line: Int = #line ) {
    DLOG("\(function):\(file):\(line): ERROR:: \(string)")
}
