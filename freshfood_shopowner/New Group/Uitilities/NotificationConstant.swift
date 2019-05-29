//
//  NotificationConstant.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/5/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation


enum Notification : String {
    
    case noData = "No data to show"
    
    case noFood = "No food to show"
    
    case noSearchResult = ""
    
    case notLogedIn = "Please login to use this task"
    
    case newShop = "All the information are required"
    
    
    enum comment : String {
        case nilWithInfor = "All the information are required"
        case addCmtFailedTitle = "Something went wrong"
        case addCmtFailedMessgae = "Please try another time"
        case titleNotValid = "The title has only letters, underscores and numbers allowed"
        case contentNotValid = "The content has only letters, underscores and numbers allowed"
    }
    
    
    
    enum username : String {
        case title = "Invalid username"
        case detail = "Only letters, underscores, numbers, and Length should 4-20"
    }
    
    enum canNotLogIn : String {
        case title = "Can not log in"
        case detail = "Your email and password do not match any account"
    }
    
    enum phoneNumber : String {
        case title = "Invalid phone number"
        case detail = "Only 10 numbers"
    }
    
    enum email : String {
        case title = "Invalid email address"
        case detail = "Please enter a valid email address"
    }
    
    enum password : String {
        case title = "Invalid new password"
        case detail = "Only letters, underscores, and numbers"
    }
    
    enum confirmPass : String {
        case title = "Invalid confirm password"
        case detail = "Does not match with password"
    }
    
    
}
