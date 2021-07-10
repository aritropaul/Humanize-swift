//
//  File.swift
//  
//
//  Created by Aritro Paul on 7/8/21.
//

import Foundation


/// Bits and bytes Humanization
extension Humanize {
    
    /// Format a number of bytes like a human readable filesize (e.g. 10 KB).
    /// By default, decimal suffixes (KB, MB) are used.
    ///
    /// - Parameters:
    ///     - bytes: Integer value in bytes to convert.
    ///     - type: conversion type. Choose from decimal, binary or memory
    /// ```
    ///    Humanize().naturalSize(2204) // 2.2KB
    ///    Humanize().naturalSize(2747829994) // 2.75GB
    ///    Humanize().naturalSize(2747829994, type: .binary) // 2.56 GB
    /// ```
    /// - Returns: Human readable representation of a filesize.
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
