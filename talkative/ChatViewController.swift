//
//  ChatViewController.swift
//  talkative
//
//  Created by Ziad Hamdieh on 2018-05-11.
//  Copyright © 2018 Ziad Hamdieh. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class ChatViewController: UIViewController {
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up this VC as the delegate and data source
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        // register cell's .xib
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        
    }
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
    
        
        
    }
    
    
    @IBAction func signOutPressed(_ sender: AnyObject) {
        
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("Error signing out")
            ProgressHUD.showError("Check Internet Connection")
        }
        
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        let messageArray = ["first", "second", "third"]
        cell.message.text = messageArray[indexPath.row]
//        cell.imageView?.image = UIImage(named: "")
//        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)! / 2
//        cell.imageView?.layer.masksToBounds = true
        return cell
        
    }
    
    
}
