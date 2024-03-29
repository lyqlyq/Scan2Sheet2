//
//  ShortCode.swift
//  ShortCode
//
//  Created by Reid Chatham on 3/15/16.
//  Copyright © 2016 Reid Chatham. All rights reserved.
//

// https://stackoverflow.com/questions/9543715/generating-human-readable-usable-short-but-unique-ids
import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

/**
 Struct consisting entirely of static stateless contructors for generating unique short codes.
 */
public struct ShortCode {
    
    public static let base62chars = [Character]("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
    public static let maxBase : UInt32 = 62
    
    
    public static func getCode(withBase base: UInt32 = ShortCode.maxBase, length: Int) -> String {
        var code = ""
        let base = min(base, ShortCode.maxBase)
        for _ in 0..<length {
            #if os(Linux)
                let rand = Int(random() % (base))
            #else
                let rand = Int(arc4random_uniform(base))
            #endif
            code.append(base62chars[rand])
        }
        return code
    }
    
    public static func getCode(withBase base: UInt32 = ShortCode.maxBase, length: Int, retryLimit limit: Int? = nil, uniquenessCheck: (String)->Bool = {_ in true}) -> String? {
        
        guard limit != nil ? limit! > 0 : true else { return nil }
        
        var code = ""
        let base = min(base, ShortCode.maxBase)
        for _ in 0..<length {
            #if os(Linux)
                let rand = Int(random() % (base))
            #else
                let rand = Int(arc4random_uniform(base))
            #endif
            code.append(base62chars[rand])
        }
        
        if !uniquenessCheck(code) {
            return getCode(
                withBase: base,
                length: length,
                retryLimit: limit != nil ? limit!-1 : nil,
                uniquenessCheck: uniquenessCheck
            )
        }
        return code
    }
    
    public static func convertIntToBase62(integer: Int) -> String {
        var code = ""
        var currentInt = integer
        
        repeat {
            let i = currentInt % 62
            code = "\(base62chars[i])" + code
            currentInt /= 62
        } while currentInt > 0
        
        return code
    }
    
    public static func convertInt(integer: Int, toBase base: Int) -> String {
        var code = ""
        var currentInt = integer
        let base = min(base, Int(ShortCode.maxBase))
        
        repeat {
            let i = currentInt % base
            code = "\(base62chars[i])" + code
            currentInt /= base
        } while currentInt > 0
        
        return code
    }
    
    public static func convertDateToBase62(date: Date) -> String {
        let timeIntervalSinceReferenceDate = date.timeIntervalSinceReferenceDate
        let milliseconds = Int(timeIntervalSinceReferenceDate * 1000)
        
        return convertIntToBase62(integer: milliseconds)
    }
    
    public static func convertCodeToInt(code: String, withBase base: Int) -> Int {
        
        var code = [Character](code)
        var int = 0
        
        let last = code.removeLast()
        int += (base62chars.firstIndex(of: last)!)
        
        var i = base
        repeat {
            let last = code.removeLast()
            int += ((base62chars.firstIndex(of: last)!) * i)
            i *= base
        } while !code.isEmpty
        
        return int
    }
    
    public static func convertBase62toInt(code: String) -> Int {
        
        var code = [Character](code)
        var int = 0
        
        let last = code.removeLast()
        int += (base62chars.firstIndex(of: last)!)
        
        var i = 62
        repeat {
            let last = code.removeLast()
            int += ((base62chars.firstIndex(of: last)!) * i)
            i *= 62
        } while !code.isEmpty
        
        return int
    }
    
    public static func convertBase62Date(code: String) -> Date {
        let int = convertBase62toInt(code: code)
        return Date(timeIntervalSinceReferenceDate: Double(int)/1000)
    }
    
    public static func convertCode(code: String, withBase base1: Int, toCodeWithBase base2: Int) -> String {
        let integer = convertCodeToInt(code: code, withBase: base1)
        return convertInt(integer: integer, toBase: base2)
    }
}
