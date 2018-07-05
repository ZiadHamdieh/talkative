//
//  messageCell.swift
//  talkative
//
//  Created by Ziad Hamdieh on 2018-05-23.
//  Copyright © 2018 Ziad Hamdieh. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var messageBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }  
    
}

