//
//  message.swift
//  talkative
//
//  Created by Ziad Hamdieh on 2018-05-11.
//  Copyright © 2018 Ziad Hamdieh. All rights reserved.
//

final class Message {
    
    var messageContent = ""
    var sender = ""
    
    init(msg: String, user: String) {
        messageContent = msg
        sender = user
    }
}
