//
//  LogInViewController.swift
//  talkative
//
//  Created by Ziad Hamdieh on 2018-05-11.
//  Copyright © 2018 Ziad Hamdieh. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class LogInViewController: UIViewController {
    

    @IBOutlet weak var email: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func logInPressed(_ sender: AnyObject) {
        Auth.auth().signIn(withEmail: email.text!,
                           password: password.text!) {
                            (result, error) in
                            
                            if error == nil {
                                ProgressHUD.showSuccess("Chat on, my dude!")
                                
                                self.performSegue(withIdentifier: "goToChatScreen", sender: self)
                            }
                            else {
                                print(error!)
                                ProgressHUD.showError("Oops. Something went wrong.")
                            }
        }
        
    }
    
    
}
