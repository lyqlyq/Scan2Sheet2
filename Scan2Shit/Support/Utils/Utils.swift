//
//  Utils.swift
//  iMusic
//
//  Created by Cuong on 8/16/17.
//  Copyright © 2017 HCM. All rights reserved.
//

import UIKit

// MARK: - PATHS
let app_delegate = UIApplication.shared.delegate as! AppDelegate

class Utils: NSObject {    
    static let numberFormatter : NumberFormatter = {
        var num = NumberFormatter()
        num.numberStyle = .decimal
        num.groupingSeparator = "."
        return num
    }()
    
    static func convertDurationFromFloat(_ duration: Float) -> String{
        let hour : Int = Int((duration / 3600))
        let minute : Int = Int((duration - Float(hour * 3600)) / 60)
        let second : Int = Int(duration - Float(hour * 3600) - Float(minute * 60))
        
        let temp : String = "\(minute < 10 ? "0" : "")\(minute):\(second < 10 ? "0" : "")\(second)"
        
        if hour > 0{
            return "\(hour):\(temp)"
        }
        else{
            return temp
        }
    }
    
    static func convertNumberToNicelyReading(_ numberInString : String?) -> String{
        if let string = numberInString{
            let number : CLongLong = CLongLong(string) ?? 0
            
            if number < 10000 {
                return "\(Int(number))"
            }
            else if number < 1000_000 {
                let numberInt = Int(number / 1000)
                return "\(numberInt)K"
            }
            else {
                let numberInt = Int(number / 1000_000)
                return "\(numberInt)M"
            }
        }
        else{
            return ""
        }
    }
    
    static func nicelyReadingForNumber(_ number : NSNumber) -> String {
        return Utils.numberFormatter.string(from: number) ?? ""
    }
    
    static func appDelegate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    static func WIDTHSCREEN() -> CGFloat{
        return (Utils.appDelegate().window?.frame.size.width)!
    }
    
    static func HEIGHTSCREEN() -> CGFloat{
        return (Utils.appDelegate().window?.frame.size.height)!
    }
}
