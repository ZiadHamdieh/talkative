//
//  ChatViewController.swift
//  talkative
//
//  Created by Ziad Hamdieh on 2018-05-11.
//  Copyright © 2018 Ziad Hamdieh. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase
import ProgressHUD

class ChatViewController: UIViewController {
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    // array that holds message objects sent by users
    var messages : [Message] = [Message]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up appropriate delegates and dataSource
        messageTextfield.delegate = self
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        // register cell's .xib
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        
        // resize the tableview based on the size of the messages upon loading
        resizeTableView()
        receiveMessages()
        
        messageTableView.separatorStyle = .none
        
        // register a TableView to monitor tap gestures by user.
        // We can then use this to figure out when the user is clicking away from the message text box
        let userTappedScreen = UITapGestureRecognizer(target: self, action: #selector(tableViewWasTapped))
        
        // add tap gesture to the table view
        messageTableView.addGestureRecognizer(userTappedScreen)
        
        // TODO: resize keyboard to the size appropriate for user's screen size
        
    }
    
    @objc func tableViewWasTapped() {
        // this method calls textFieldDidEndEditing() which in turn resizes
        // the message box text field back to default when user has finished editing the message
        messageTextfield.endEditing(true)
    }
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        // first, resize chat box to original dimensions
        messageTextfield.endEditing(true)
        let message = messageTextfield.text
        messageTextfield.text = ""
        
        
        // then store the message entered by the user into Firebase db,
        // making sure to disable user input to avoid duplicate
        // messages in the chat
        sendButton.isEnabled = false
        messageTextfield.isEnabled = false
        let msgDB = Database.database().reference().child("Messages")
        let msgDict = ["messageSender": Auth.auth().currentUser?.email,
                       "messageContent": message]
        
        // create random key for this message
        msgDB.childByAutoId().setValue(msgDict) {
            (error, reference) in
            
            if error == nil {
                print("message was saved in the database")
                // finally, re-enable user input
                self.sendButton.isEnabled = true
                self.messageTextfield.isEnabled = true
            }
            else  {
                print(error!)
            }
        }
    }
    
    func receiveMessages() {
        // point to the same database where sent messages are stored by sendPressed()
        let msgDB = Database.database().reference().child("Messages")
        
        // observe for eventType: childAdded
        msgDB.observe(.childAdded) {
            (snapshot) in
            // grab data within the snapshot and format into a Message object
            
            // Note: snapshot.value must be cast to a dictionary in order to use it
            let snapshotResult = snapshot.value as! Dictionary<String, String>
            let content = snapshotResult["messageContent"]!
            let sender = snapshotResult["messageSender"]!
            
            // instantiate a new Message object and append it to messages[]
            let retrievedMessage = Message(msg: content, user: sender)
            self.messages.append(retrievedMessage)
            self.resizeTableView()
            self.messageTableView.reloadData()
            
            // finally, scroll down to the most recent message
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0);
            self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    @IBAction func signOutPressed(_ sender: AnyObject) {
        do {
            try Auth.auth().signOut()
            // pop all views from the stack and return to root view (i.e. the welcome screen)
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("Error signing out")
            ProgressHUD.showError("Check Internet Connection")
        }
    }
    
    // resize TableView if user's entered message is too long to fit
    // in the chat box's current dimensions
    func resizeTableView() {
        messageTableView.estimatedRowHeight = 100.0
        messageTableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension ChatViewController: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        cell.message.text = messages[indexPath.row].messageContent
        cell.userName.text = messages[indexPath.row].sender
        cell.backgroundColor = UIColor(rgb: 0xd6f5fc)
        
        let image = UIImage(named: "defaultAvatar")
        cell.userImageView.image = image
        cell.userImageView.layer.cornerRadius = (cell.userImageView.frame.height)/2
        cell.userImageView.layer.masksToBounds = true
        
        // Distinguish between messages we sent ourselves and messages sent by others
        if Auth.auth().currentUser?.email == cell.userName.text as String? {
            cell.messageBackground.backgroundColor = .flatSkyBlue()
        }
        else {
            cell.messageBackground.backgroundColor = .flatPowderBlue()
        }
        
        return cell
    }
    
    // tells the delegate that editing began in the specified text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let userKeyboardHeight = 250
        let textBoxHeight = 50
        heightConstraint.constant = CGFloat(textBoxHeight + userKeyboardHeight)
        
        // tell AutoLayout to redraw screen elements after update
        view.layoutIfNeeded()
        
        // animate keyboard popup when user begins editing text field
        UIView.animate(withDuration: 0.3) {
           self.heightConstraint.constant = CGFloat(textBoxHeight + userKeyboardHeight)
           self.view.layoutIfNeeded()
        }
    }
    
    // tells the delegate that editing stopped in the specified text field
    // NOTE: This method does not get called by default, so we use tap gesture methods
    // to trigger it ( see tableViewWasTapped() )
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
        
    }
}

// Extra extension to UIColor to use hexadecimal values in setting background colors
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
