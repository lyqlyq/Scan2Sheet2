//
//  Benchmark.swift
//  FrRadio
//
//  Created by Admin on 4/16/18.
//  Copyright © 2018 HCM. All rights reserved.
//

import Foundation

class Benchmark {
    // return time in seconds
    static func benmark(_ block: ()->()) -> Double {
        let startTime = DispatchTime.now()
        
        block()
        
        let endTime = DispatchTime.now()
        let timeInterval = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000
        return timeInterval
    }
}
