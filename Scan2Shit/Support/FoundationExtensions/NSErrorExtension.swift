//
//  NSErrorExtension.swift
//  SongsTransfer
//
//  Created by cuongab on 4/12/19.
//  Copyright © 2019 HCM. All rights reserved.
//

import UIKit

extension NSError {
    convenience init(code: Int, message: String) {
        self.init(domain: Bundle.main.bundleIdentifier!, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
