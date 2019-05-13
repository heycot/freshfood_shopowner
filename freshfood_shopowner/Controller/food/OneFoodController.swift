//
//  OneFoodController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/13/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class OneFoodController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var unit: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var item = ShopItemResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateView()
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    func updateView() {
        let priceFormat = (item.price?.formatPrice())!
        let priceStr = "VND " + String(priceFormat).replace(target: "$", withString: "")    + "/\(item.unit!)"
        
        name.text = item.name
        price.text = priceStr
        unit.text = item.unit
        
    }
    
    func getAllComment() {
        
    }
    
    
    @IBAction func photosPressed(_ sender: Any) {
    }
    
    
    func registerCell() {
        
    }
    
}

extension OneFoodController : UITableViewDelegate {
    
}


extension OneFoodController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
