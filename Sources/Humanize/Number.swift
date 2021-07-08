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
    
}
