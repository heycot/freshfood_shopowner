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
    
    
    // firebase variale
    //    private var channelReference: CollectionReference {
    //        return db.collection("channels").whereField("users", arrayContains: user.id ?? "") as! CollectionReference
    //    }
    
    var channels = [Channel]()
    //    private var channelListener: ListenerRegistration?
    
    var user = UserResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupUser()
        viewListChannel()
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
                self.notification.text = "No data to show"
                self.notification.isHidden = false
            }
            
            self.channels = data
            self.tableView.reloadData()
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
                let userID = Auth.auth().currentUser?.uid
                self.notification.isHidden = true
                AuthServices.instance.getProfile(userID: userID ?? "", completion: { (data) in
                    guard let data = data else { return }
                    self.user = data
                    self.addSnapshot()
                })
                
            } else {
                self.notification.text = "Please sign in to use this task"
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
        guard !channels.contains(channel) else {
            return
        }
        
        channels.append(channel)
        channels.sort()
        
        guard let index = channels.index(of: channel) else {
            return
        }
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateChannelInTable(_ channel: Channel) {
        guard let index = channels.index(of: channel) else {
            return
        }
        
        channels[index] = channel
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeChannelFromTable(_ channel: Channel) {
        guard let index = channels.index(of: channel) else {
            return
        }
        
        channels.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
}

extension ChannelViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCellID", for: indexPath) as! ChannelCell
        
        cell.accessoryType = .disclosureIndicator
        cell.updateView(channel: channels[indexPath.row], userID: user.id ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[indexPath.row]
        let vc = ChatViewController(user: user, channel: channel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
