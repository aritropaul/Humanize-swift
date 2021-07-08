//
//  File.swift
//  
//
//  Created by Aritro Paul on 7/8/21.
//

import Foundation

extension Humanize {
    
    func ordinal(_ value: Int) -> String {
        let suffix = [ "th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th"]
        if [11, 12, 13].contains(value % 100) {
            return "\(value)\(suffix[0])"
        }
        else {
            return "\(value)\(suffix[value % 10])"
        }
    }
    
    func comma(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(floatLiteral: value))!
    }
    
    private func power(_ x: Int) -> Int {
        return Int(pow(10, Double(x)))
    }
    
    func word(_ value: Int) -> String {
        
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
                        let choppedStr = String(format: "%.2f", chopped)
                        return "\(choppedStr) \(humanizedPowers[index])"
                    }
                    else {
                        let choppedStr = String(format: "%.2f", chopped)
                        return "\(choppedStr) \(humanizedPowers[index - 1])"
                    }
                }
            }
        }
        
        return ""
    }
    
    
    func APNumber(_ value: Int) -> String {
        if value < 0 || value > 10 {
            return "\(value)"
        }
        else {
            return ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"][value]
        }
    }
    
    
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
    
    
    func fraction(_ value: Double) -> String {
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
    
    
    func scientific(_ value: Double) -> String {
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
        if "\(value)".contains("-") {
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
    
    func clamp(_ value: Double, floor: Double? = nil, ceil: Double? = nil) -> String {
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
