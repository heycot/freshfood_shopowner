//
//  AddFoodController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class AddFoodController: UIViewController {

    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationHeight: NSLayoutConstraint!
    
    var arrayCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell() 
        setupView()
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView =  UIView()
    }
    
    func registerCell() {
        
        tableView.register(UINib(nibName: CellIdentifier.newFood.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.newFood.rawValue)
    }
    
    @IBAction func newFoodPressed(_ sender: Any) {
        
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: arrayCount - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
        arrayCount += 1
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
    }
    
    
}

extension AddFoodController : UITableViewDelegate {
    
}

extension AddFoodController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.newFood.rawValue, for: indexPath) as! NewFoodCell
        
        return cell
    }
    
    
}
