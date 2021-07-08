//
//  File.swift
//  
//
//  Created by Aritro Paul on 7/8/21.
//

import Foundation

extension Humanize {
    
    public func naturalSize(_ bytes: Int, type: Suffix = .decimal) -> String {
        let formatter = ByteCountFormatter()
        switch type {
        case .decimal: formatter.countStyle = .decimal
        case .binary: formatter.countStyle = .binary
        case .memory: formatter.countStyle = .memory
        }
        return formatter.string(fromByteCount: Int64(bytes))
    }
    
}
