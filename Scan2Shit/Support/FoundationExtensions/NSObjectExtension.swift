//
//  NSObjectExtension.swift
//  iMusic
//
//  Created by Cuong on 8/15/17.
//  Copyright © 2017 HCM. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
