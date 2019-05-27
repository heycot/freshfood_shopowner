//
//  FindUserController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/27/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//
import UIKit
import PKHUD

class FindUserController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notification: UILabel!
    
    let searchBar = UISearchBar()
    var listUser = [UserResponse]()
    var user = UserResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = APP_COLOR
        notification.isHidden = true
        createSearchBar()
        setupTableView()
    }
    
    func createSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = " Search here"
        searchBar.delegate = self
        searchBar.tintColor = .black
        
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        self.tableView.reloadData()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 80
    }
    
    @objc func search() {
        HUD.show(.progress)
        
        AuthServices.instance.search(searchText: searchBar.text!.lowercased()) { (data) in
            guard let data = data else { return }
            self.listUser = data
            
            HUD.hide()
            self.tableView.reloadData()
        }
    }
    
    func pushChatViewController(index: Int) {
        var channel = Channel()
        
        var folder = ReferenceImage.user.rawValue + "\(self.user.avatar ?? "")"
        channel.is_with_shop = 0
        channel.user_id_first = self.user.id ?? ""
        channel.name_first = self.user.name ?? ""
        channel.image_first = folder
        
        folder = ReferenceImage.user.rawValue + "\(listUser[index].avatar ?? "")"
        channel.user_id_second = listUser[index].id ?? ""
        channel.name_second = listUser[index].name ?? ""
        channel.image_second = folder
        
        var users = [String]()
        users.append(self.user.id ?? "")
        users.append(listUser[index].id ?? "")
        channel.users = users
        
        let vc = ChatViewController(user: self.user, channel: channel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension FindUserController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.userCell.rawValue ) as! UserCell
        
        cell.updateView(user: listUser[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        pushChatViewController(index: indexPath.row)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
}


// handle UISearchBar
extension FindUserController: UISearchBarDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
        
        searchBar.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}
