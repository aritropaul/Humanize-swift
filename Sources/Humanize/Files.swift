//
//  File.swift
//  
//
//  Created by Aritro Paul on 7/8/21.
//

import Foundation

extension Humanize {
    
    private static let suffixes = [
        Suffix.decimal : ["KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"],
        Suffix.binary : ["KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"]
    ]
    
    public func naturalSize(_ bytes: Int, type: Suffix = .decimal) -> String {
        
        let suffix = Humanize.suffixes[type]
        var base = 1024
        
        
        if type == .binary {
            base = 1024
        }
        else {
            base = 1000
        }
        
        if bytes == 1 {
            return ("\(bytes) byte")
        }
        else if bytes < base {
            return ("\(bytes) bytes")
        }
        
        for index in suffix!.indices {
            let s = suffix![index]
            let unit = pow(Double(base), Double(index+2))
            if bytes < Int(unit) {
                let value = (Double(base * bytes) / unit)
                return String(format: "%.2f", value) + " \(s)"
            }
        }
        
        return ""
    }
    
}
