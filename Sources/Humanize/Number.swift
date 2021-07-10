//
//  Number.swift
//  
//
//  Created by Aritro Paul on 7/8/21.
//

import Foundation

/// Numbers Humanization
extension Humanize {
    
    /// Converts an integer to its ordinal as a string.
    /// For example, 1 is "1st", 2 is "2nd", 3 is "3rd", etc. Works for any integer or
    /// anything `Int()` will turn into an integer. 
    /// ```
    ///     Humanize().ordinal(1) // 1st
    ///     Humanize().ordinal(1002) // 1002nd
    /// ```
    /// - Parameter value: Integer to convert
    /// - Returns: Ordinal string
    public func ordinal(_ value: Int) -> String {
        let suffix = [ "th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th"]
        if [11, 12, 13].contains(value % 100) {
            return "\(value)\(suffix[0])"
        }
        else {
            return "\(value)\(suffix[value % 10])"
        }
    }
    
    /// Converts an integer to a string containing commas every three digits.
    /// For example, 3000 becomes "3,000" and 45000 becomes "45,000".
    /// ```
    ///     Humanize().comma(100) // 100
    ///     Humanize().comma(1000) // 1,000
    ///     Humanize().comma(12345678) // 12,345,678
    /// ```
    /// - Parameter value: Integer or float to convert
    /// - Returns: string containing commas every three digits.
    public func comma(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.hasThousandSeparators = true
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(floatLiteral: value))!
    }
    
    /// Returns pow(x, y)
    /// - Parameter x: exponent
    /// - Parameter base: base
    /// - Returns: Integer
    private func power(_ x: Int, base: Int = 10) -> Int {
        return Int(pow(10, Double(x)))
    }
    
    
    
    /// Converts a large integer to a friendly text representation.
    /// Works best for numbers over 1 million. For example, 1000000 becomes "1.0 million",
    /// 1200000 becomes "1.2 million" and "1200000000" becomes "1.2 billion". Supports up
    /// to decillion (33 digits) and googol (100 digits).
    /// ```
    ///     Humanize().word(12400) // 12.4 thousand
    ///     Humanize().word(1000000) // 1.0 million
    /// ```
    /// - Parameter value: Integer to convert
    /// - Returns: Friendly text representation as a `String`.
    public func word(_ value: Int) -> String {
        
        let powers = [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 100]
        let humanizedPowers = ["thousand", "million", "billion", "trillion", "quadrillion", "quintillion", "sextillion", "septillion", "octillion", "nonillion", "decillion", "googol"]
        
        if value < power(powers[0]) {
            return ("\(value)")
        }
        else {
            for index in powers[1...11].indices {
                if value < power(powers[index]) {
                    var chopped = Double(value) / Double(power(powers[index-1]))
                    if Int(chopped) == power(powers[0]) {
                        chopped = Double(value) / Double(power(powers[index]))
                        var choppedStr = String(format: "%.2f", chopped)
                        if choppedStr.last == "0" {
                            choppedStr = String(choppedStr.dropLast())
                        }
                        return "\(choppedStr) \(humanizedPowers[index])"
                    }
                    else {
                        var choppedStr = String(format: "%.2f", chopped)
                        if choppedStr.last == "0" {
                            choppedStr = String(choppedStr.dropLast())
                        }
                        return "\(choppedStr) \(humanizedPowers[index - 1])"
                    }
                }
            }
        }
        
        return ""
    }
    
    
    /// Converts an integer to Associated Press style.
    /// ```
    ///     Humanize().APNumber(9) // "nine"
    ///     Humanize().APNumber(41) // "41"
    ///
    /// ```
    /// - Parameter value: Integer to convert
    /// - Returns: For numbers 0-9, the number spelled out. Otherwise, the number. This always returns a `String`.
    public func APNumber(_ value: Int) -> String {
        if value < 0 || value > 10 {
            return "\(value)"
        }
        else {
            return ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"][value]
        }
    }
    
    /// Fraction Representation
    private struct Fraction {
        let numerator : Int
        let denominator: Int

        init(numerator: Int, denominator: Int) {
            self.numerator = numerator
            self.denominator = denominator
        }

        init(_ value: Double, withPrecision eps: Double = 1.0E-3) {
            var x = value
            var a = x.rounded(.down)
            var (h1, k1, h, k) = (1, 0, Int(a), 1)

            while x - a > eps * Double(k) * Double(k) {
                x = 1.0/(x - a)
                a = x.rounded(.down)
                (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
            }
            self.init(numerator: h, denominator: k)
        }
    }
    
    /// Convert to fractional number.
    /// There will be some cases where one might not want to show ugly decimal places for
    /// floats and decimals.
    /// This function returns a human-readable fractional number in form of fractions and
    /// mixed fractions.
    ///   ```
    ///        Humanize().fraction(0.3) // 3/10
    ///        Humanize().fraction(0.4456) // 41/92
    ///   ```
    /// - Parameter value: Integer or Float to convert.
    /// - Returns: Fractional number as a string.
    public func fraction(_ value: Double) -> String {
        let wholeNumber = Int(value)
        let frac = Fraction(value - Double(wholeNumber))
        let numerator = frac.numerator
        let denominator = frac.denominator
        
        if wholeNumber >= 0 && denominator == 1 {
            return String(format: "%.1f", value)
        }
        else if wholeNumber > 0 {
            return "\(wholeNumber) \(numerator)/\(denominator)"
        }
        else {
            return "\(numerator)/\(denominator)"
        }
    }
    
    
    
    /// Return number in string scientific notation z.wq x 10ⁿ
    /// ```
    ///     Humanize().scientific(0.33) // 3.30 × 10⁻¹
    /// ```
    ///  - Parameter value: Integer or Float  number
    ///  - Returns: Number in scientific notation z.wq x 10ⁿ
    public func scientific(_ value: Double) -> String {
        let exponents = [
            "0": "⁰",
            "1": "¹",
            "2": "²",
            "3": "³",
            "4": "⁴",
            "5": "⁵",
            "6": "⁶",
            "7": "⁷",
            "8": "⁸",
            "9": "⁹",
            "+": "⁺",
            "-": "⁻",
        ]
        var negative = false
        var absValue = value
        if "\(value)".components(separatedBy: "e")[0].contains("-") {
            absValue = abs(value)
            negative = true
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 2
        let stringValue = formatter.string(from: NSNumber(floatLiteral: absValue)) ?? ""
        
        let parts = stringValue.components(separatedBy: "E")
        var part1 = parts[0]
        var part2 = parts[1]
        
        if part2.contains("-0") {
            part2 = part2.replacingOccurrences(of: "-0", with: "0")
        }
        if part2.contains("0") && part2.count == 1 {
            part2 = part2.replacingOccurrences(of: "0", with: "")
        }
        var newPart2 = ""
        if negative {
            part1 = "-" + part1
        }
        for char in part2 {
            newPart2 += exponents[String(char)]!
        }
        
        let finalString = part1 + " × 10" + newPart2
        return finalString
    }
    
    
    /// Returns number with the specified format, clamped between floor and ceil.
    /// If the number is larger than ceil or smaller than floor, then the respective limit
    /// will be returned, formatted and prepended with a token specifying as such.
    /// - Parameters:
    ///   - value: Integer or Float number
    ///   - floor: Smallest value before clamping.
    ///   - ceil: Largest value before clamping.
    /// - Returns: Formatted number. The output is clamped between the indicated floor and ceil. If the number if larger than ceil or smaller than floor, the output will be prepended with a token indicating as such.
    public func clamp(_ value: Double, floor: Double? = nil, ceil: Double? = nil) -> String {
        var token = ""
        var mutValue = value
        if floor != nil {
            if value < (floor!) {
                mutValue = floor!
                token = "<"
            }
        }
        else if ceil != nil {
            if value > (ceil!) {
                mutValue = ceil!
                token = ">"
            }
        }
        else { token = "" }
        return token + "\(mutValue)"
    }
    
}
