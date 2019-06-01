//
//  ChannelViewController.swift
//  freshfood_shopowner
//
//  Created by Tu (Callie) T. NGUYEN on 5/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ChannelViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notification: UILabel!
    
    var channels_shop = [Channel]()
    var channels_user = [Channel]()
    
    var userID = ""
    var user = UserResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupUser()
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: SegueIdentifier.channelToFindUser.rawValue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is FindUserController {
            let vc = segue.destination as? FindUserController
            vc?.user = self.user
        }
    }
    
    func viewListChannel() {
        ChannelServices.instance.getAllChannelByUser { (data) in
            guard let data = data else { return }
            
            if data.count == 0 {
                self.notification.text = NSLocalizedString("No data to show", comment: "")
                self.notification.isHidden = false
            }
            
            for item in data {
                if item.is_with_shop == 1 {
                    self.channels_shop.append(item)
                } else {
                    self.channels_user.append(item)
                }
            }
            self.tableView.reloadData()
            
            AuthServices.instance.getProfile(userID: self.userID , completion: { (data) in
                guard let data = data else { return }
                self.user = data
                self.addSnapshot()
            })
        }
    }
    
    func addSnapshot() {
        
        let db = Firestore.firestore()
        
        db.collection("channels").whereField("users", arrayContains: self.user.id ?? "").addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
            
            if error != nil {
                print("error with snapshot")
            }
            
            snapshot?.documentChanges.forEach({ (change) in
                self.handleDocumentChange(change)
            })
        }
    }
    
    func setupUser() {
        AuthServices.instance.checkLogedIn { (data) in
            guard let data = data else { return }
            
            if data {
                self.userID = Auth.auth().currentUser?.uid ?? ""
                self.notification.isHidden = true
                self.viewListChannel()
                
            } else {
                self.notification.text = NSLocalizedString("Please sign in to use this task", comment: "")
            }
        }
    }
    
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let channel = Channel(document: change.document) else {
            return
        }
        
        switch change.type {
        case .added:
            addChannelToTable(channel)
            
        case .modified:
            updateChannelInTable(channel)
            
        case .removed:
            removeChannelFromTable(channel)
        }
    }
    
    private func addChannelToTable(_ channel: Channel) {
        var index = 0
        
        if channel.is_with_shop == 1 {
            
            guard !channels_shop.contains(channel) else {
                return
            }
            
            channels_shop.append(channel)
            channels_shop.sort()
            
            guard let indexNew = channels_shop.index(of: channel)  else {
                return
            }
            
            index = indexNew
        } else {
            guard !channels_user.contains(channel) else {
                return
            }
            
            channels_user.append(channel)
            channels_user.sort()
            
            guard  let indexNew = channels_user.index(of: channel) else {
                return
            }
            index = indexNew
        }
        
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateChannelInTable(_ channel: Channel) {
        var index = 0
        
        if channel.is_with_shop == 1 {
            
            guard let indexNew = channels_shop.index(of: channel) else {
                return
            }
            
            channels_shop[index] = channel
            index = indexNew
        } else {
            guard let indexNew = channels_user.index(of: channel) else {
                return
            }
            
            channels_user[index] = channel
            index = indexNew
        }
        
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeChannelFromTable(_ channel: Channel) {
        var index  = 0
        
        if channel.is_with_shop == 1 {
            
            guard let indexNew = channels_shop.index(of: channel) else {
                return
            }
            
            index = indexNew
            channels_shop.remove(at: indexNew)
        } else {
            guard let indexNew = channels_user.index(of: channel) else {
                return
            }
            
            index = indexNew
            channels_user.remove(at: indexNew)
        }
        
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
}

extension ChannelViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("Customers", comment: "")
        } else {
            return NSLocalizedString("Friends", comment: "")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return channels_shop.count
        } else {
            
            return  channels_user.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCellID", for: indexPath) as! ChannelCell
        
        cell.accessoryType = .disclosureIndicator
        if indexPath.section == 0 {
            cell.updateView(channel: channels_shop[indexPath.row], userID: user.id ?? "", isShop: true)
        } else {
            
            cell.updateView(channel: channels_user[indexPath.row], userID: user.id ?? "", isShop: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var channel : Channel?
        if indexPath.section == 0 {
            channel = channels_shop[indexPath.row]
        } else {
            channel = channels_user[indexPath.row]
        }
        
        let vc = ChatViewController(user: user, channel: channel!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
