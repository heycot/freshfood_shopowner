//
//  ListFoodsController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/11/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class ListFoodsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var notificationHeight: NSLayoutConstraint!
    
    var ShopItemList = [ShopItemResponse]()
    var shopID = ""
    var itemList = [ItemResponse]()
    var newItems = [ItemResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.getListItem()
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        self.tableView.reloadData()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 90
    }
    
    func getList() {
        ShopItemService.instance.getListShopItem(shopID: shopID) { (data) in
            guard let data = data else { return }
            
            self.ShopItemList = data
            self.tableView.reloadData()
            self.getItemNotAlreadyExists()
        }
    }
    
    func getListItem() {
        ItemService.instance.getAllItem { (data) in
            guard let data = data else { return }
            self.itemList = data
        }
    }
    
    func getItemNotAlreadyExists() {
        for item in itemList {
            if !checkItemInList(itemID: item.id ?? "") {
                newItems.append(item)
            }
        }
    }
    
    func checkItemInList(itemID: String) -> Bool {
        for item in ShopItemList {
            if item.item_id == itemID {
                return true
            }
        }
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is OneFoodController {
            let vc = segue.destination as? OneFoodController
            let index = sender as! Int
            vc?.item = ShopItemList[index]
        } else if segue.destination is AddFoodController {
            let vc = segue.destination as? AddFoodController
            vc?.itemList = newItems
        }
    }
}


extension ListFoodsController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifier.listFoodToOne.rawValue, sender: indexPath.row)
    }
    
    
}

extension ListFoodsController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShopItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.food.rawValue, for: indexPath) as! FoodCell
        cell.updateView(item: ShopItemList[indexPath.row])
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getList()
        super.viewWillAppear(true)
        tableView.reloadData()
    }
}
