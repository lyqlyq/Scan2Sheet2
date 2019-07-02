//
//  Platform.swift
//  FlacPlayer
//
//  Created by Cuong on 10/9/17.
//  Copyright © 2017 HCM. All rights reserved.
//

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if targetEnvironment(simulator)
        isSim = true
        #endif
        return isSim
    }()
}
