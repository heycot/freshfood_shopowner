//
//  ListCommentController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/16/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class ListCommentController: UIViewController {

    
    var shopList = [ShopResponse]()
    var cmtList = [CommentResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        
    }
    
    func getComment() {
        ShopService.instance.getListShop { (data) in
            guard let data = data else { return }
            self.shopList = data
            
            for shop in self.shopList {
                CommentServices.instance.getCommentByShopId(shopID: shop.id ?? "", completion: { (data) in
                    guard let data = data else { return}
                    
                    for cmt in data {
                        self.cmtList.append(cmt)
                    }
                })
            }
        
        }
    }
    
}
