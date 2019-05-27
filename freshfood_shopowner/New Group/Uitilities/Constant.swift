//
//  Constant.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionHander = (_ Success: Bool) -> ()

// Base url
//let BASE_URL        = "https://nutrition-vendors.herokuapp.com/api/"
//let BASE_URL        = "http://192.168.21.59:3001/api/"
//let BASE_URL_IMAGE  = "http://192.168.21.59:3001/images/"
let BASE_URL          = "http://192.168.21.59:3000/api/"
let BASE_URL_IMAGE    = "http://192.168.21.59:3000/images/"
//let BASE_URL        = "http://192.168.137.1:3001/api/"
//let BASE_URL_IMAGE  = "http://192.168.137.1:3001/images/"

// User URL enum
enum UserAPI: String {
    case register    = "user/signup"
    case login       = "user/login"
    case getInfor    = "user/infor"
    case checkPass   = "user/check"
    case changePass  = "user/change"
    case editInfor   = "user/edit"
}

enum ShopItemAPI: String {
    case getHighRating = "shop-item/high-rating/offset"
    case getOneById = "shop-item"
    case searchOne = "shop-item/search"
    case getAllLoved = "shop-item/love"
    case findByCategory = "shop-item/category"
    case getRating = "shop-item/rating"
    case findByShop = "shop-item/shop"
    case getOneDTO = "shop-item/dto"
}

enum SearchAPI: String {
    case recentSearch = "recent-search/offset"
}

enum FavoritesAPI: String {
    case loveOne = "favorites/love"
    case getAllByUser = "favorites/user"
    case checkStatus = "favorites/check"
    case countByShopItem = "favorites/count"
}

enum CommentAPI: String {
    case addNew = "comment/add"
    case edit = "comment/edit"
    case getByShopItem = "comment/shopitem"
    case countByShopItem = "comment/count"
    case getUserComment = "comment/check/shopitem"
    case getUserCommentDTO = "comment/dto/offset"
    case deleteOne = "comment/delete"
}

enum CategoryAPI: String {
    case findAll = "category"
}

enum ShopAPI: String {
    case newest = "shop/newest"
    case nearest = "shop/nearest"
    case getOne = "shop"
}


//user defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "email"


// Header
let HEADER = [
    "Content-Type" : "application/json, charset=utf-8"
]
let HEADER_AUTH = [
    "Authorization": "Bearer \(AuthServices.instance.authToken)",
    "Content-Type" : "application/json, charset=utf-8"
]



// Constant color

let APP_COLOR = UIColor(red: CGFloat(44/255.0), green: CGFloat(166/255.0), blue: CGFloat(172/255.0), alpha: CGFloat(0.75))
//let APP_COLOR = UIColor.red

let APP_COLOR_35 = UIColor(red: CGFloat(44/255.0), green: CGFloat(166/255.0), blue: CGFloat(172/255.0), alpha: CGFloat(0.15))

let HEADER_COLOR = UIColor(red: CGFloat(82/255.0), green: CGFloat(196/255.0), blue: CGFloat(154/255.0), alpha: CGFloat(0.5))

let BORDER_TEXT_COLOR = UIColor(red: CGFloat(154/255.0), green: CGFloat(154/255.0), blue: CGFloat(154/255.0), alpha: CGFloat(0.25))

let EDIT_COLOR = UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: CGFloat(1.0), alpha: CGFloat(0.25))

enum SegueIdentifier: String {
    case loginToView = "LoginToListShop"
    case loginToSignup = "LoginToSignUP"
    case signupToListShop = "SignUpToListShop"
    
    case listShopToNew = "ListShopToNew"
    case shoptoListFood = "ShopToListFoods"
    case listShopToFood = "ListShopToFood"
    
    case listFoodToOne = "ListFoodToOne"
    case listFoodToAdd = "ListFoodToAdd"
    case newFoodToList = "AddFoodToList"
    
    case listCommentToOne = "ListCommentToOne"
    
    
    //account
    case accountToPassword = "AccountToPassword"
    case accountToEditInfor = "AccountToEditInfor"
    case accountToComment = "AccountToComment"
    
    case channelToFindUser = "ChannelToFindUser"
}

enum  CellIdentifier: String {
    case shop = "ShopCell"
    case food = "FoodCell"
    case userComment = "UserCommentCell"
    case account = "AccountCell"
    case foodImage = "FoodImageCell"
    case newFood = "NewFoodCell"
    case comment = "CommentCell"
    case noComment = "NoCommentCell"
}


// google map API key
//let GOOGLE_API_KEY = "AIzaSyAgIJ_N3H3LVx_afClZancU_0Ec6gjpUVA"
//let GOOGLE_API_KEY = "AIzaSyDgqjGBtos0e_O0vVwlJ8jI8Fa-9eYAJz8"
let GOOGLE_API_KEY = "AIzaSyBlxEJ5QetCYJGN4vvo7cCSiXNWDAfQGF0"

let DIRECTION_API_KEY = "AIzaSyC1rU8F0fBtYFA3Vsj28v3w_025sLGHX0I"



enum Icon : String{
    case price_icon = "price-tag"
    case time_icon = "alarm-clock"
    case phone_icon = "call"
    case shop_icon = "shop"
    case address_icon = "placeholder"
    case category_icon = "grid"
    case picture = "picture"
}

enum ReferenceImage : String {
    case root = "/images/"
    case shop = "shop_images/"
    case user = "user_images/"
    case shopItem = "shop_item_images/"
}
