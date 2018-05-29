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
    
    var messages : [Message] = [Message]()
    var keyboardIsPresent = false
    
    
    // MARK: - App Lifecycle
    /**********************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up appropriate delegates and dataSource
        messageTextfield.delegate = self
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        
        // register a TableView to monitor tap gestures by user.
        // We can then use this to figure out when the user is clicking away from the message text box
        let userTappedScreen = UITapGestureRecognizer(target: self, action: #selector(tableViewWasTapped))
        // add tap gesture to the table view
        messageTableView.addGestureRecognizer(userTappedScreen)
        
        // resize the tableview based on the size of the messages upon loading
        resizeTableView()
        
        receiveMessages()
        
        messageTableView.separatorStyle = .none
        
        if (messageTextfield.text?.isEmpty)! {
            sendButton.isEnabled = false
        }
        
        
//        // TODO: resize keyboard to the size appropriate for user's screen size
//        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.showKeyboard),
//                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.HideKeyboard),
//                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    // MARK: - Show/Hide keyboard
    /**********************************************************************/
    
//    @objc func showKeyboard(notification: NSNotification) {
//            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                if self.view.frame.origin.y == 0 && !keyboardIsPresent {
//                    self.view.frame.origin.y -= keyboardSize.height
//                }
//            }
//    }
//
//
//    @objc func HideKeyboard(notification: NSNotification) {
//            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                if self.view.frame.origin.y != 0 && keyboardIsPresent {
//                    self.view.frame.origin.y += keyboardSize.height
//                    tableViewWasTapped()
//                }
//            }
//    }
    
    
    // MARK: - Send/Receive messages
    /**********************************************************************/
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        // first, resize chat box to original dimensions
        messageTextfield.endEditing(true)
        
        // then store the message entered by the user into Firebase db,
        // making sure to disable user input to avoid duplicate
        // messages in the chat
        sendButton.isEnabled = false
        messageTextfield.isEnabled = false
        let msgDB = Database.database().reference().child("Messages")
        let msgDict = ["messageSender": Auth.auth().currentUser?.email,
                       "messageContent": messageTextfield.text]
        
        // create random key for this message
        msgDB.childByAutoId().setValue(msgDict) {
            (error, reference) in
            
            if error == nil {
                // finally, re-enable user input
                self.messageTextfield.text = ""
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
    
    // MARK: - Sign Out
    /**********************************************************************/
    
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
}

// MARK: - TableView & TextField delegate methods
/**********************************************************************/

extension ChatViewController: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        
        cell.message.text = messages[indexPath.row].messageContent
        cell.userName.text = messages[indexPath.row].sender
        cell.backgroundColor = UIColor(rgb: 0xd6f5fc)
        
        // avatar picture customization
        let image = UIImage(named: "defaultAvatar")
        cell.userImageView.image = image
        cell.userImageView.layer.cornerRadius = (cell.userImageView.frame.height)/2
        cell.userImageView.layer.masksToBounds = true
        
        if Auth.auth().currentUser?.email == cell.userName.text as String? {
            
            // set background to sky blue if message is from logged in user
            cell.messageBackground.backgroundColor = .flatSkyBlue()
        }
        else {
            
            // set background to powder blue if message is from another user
            cell.messageBackground.backgroundColor = .flatPowderBlue()
        }
        
        return cell
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
        
    }
    
    // disable send button if messageTextfield is empty
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !text.isEmpty{
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
        return true
    }
    
    @objc func tableViewWasTapped() {
        messageTextfield.endEditing(true)
    }
    
    // resize TableView if user's entered message is too long to fit
    // in the chat box's current dimensions
    func resizeTableView() {
        messageTableView.estimatedRowHeight = 130.0
        messageTableView.rowHeight = UITableViewAutomaticDimension
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
