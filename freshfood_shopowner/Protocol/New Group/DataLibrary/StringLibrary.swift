//
//  StringLibrary.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation


extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    
    // check username is valid or not
    //    No special characters (e.g. @,#,$,%,&,*,(,),^,<,>,!,±)
    //    Only letters, underscores and numbers allowed
    //    Length should be 20 characters max and 6 characters minimum
    func isValidUserName() -> Bool {
        let RegEx = "\\w{4,20}"
        let regex = try! NSRegularExpression(pattern: RegEx, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    //check phone number is valid or not
    //only number and must 10 digital
    func isValidPhone() -> Bool {
        let PHONE_REGEX = "^[0][1-9]\\d{8}$|^[+84][1-9]\\d{8}$"
        let regex = try! NSRegularExpression(pattern: PHONE_REGEX, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    
    // check password
    // Minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character
    //    func isValidPassword(input: String) {
    //        let PASS_REGEX = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
    //        let passTest = NSPredicate(format: "SELF MATCHES %@", PASS_REGEX)
    //        let result =  passTest.evaluateWithObject(value)
    //        return result
    //    }
    
    func isValidPassword() -> Bool {
        let PASS_REGEX  = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let regex = try! NSRegularExpression(pattern: PASS_REGEX, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        
    }
    
    // check username is valid or not
    //    No special characters (e.g. @,#,$,%,&,*,(,),^,<,>,!,±)
    //    Only letters, underscores and numbers allowed
    func isValidString() -> Bool {
        let RegEx = "\\w"
        let regex = try! NSRegularExpression(pattern: RegEx, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func formatPrice(price: Double) -> String {
        return ""
    }
    
    
}

