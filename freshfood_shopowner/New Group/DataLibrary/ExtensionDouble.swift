//
//  ExtentionDouble.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/27/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func formatPrice() -> String {
        let priceNumber = self as NSNumber
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        let priceString = currencyFormatter.string(from: priceNumber) ?? ""
        
        return priceString
    }
}
