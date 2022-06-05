//
//  Messages.swift
//  ChatApp
//
//  Created by Laptop World on 28/10/1443 AH.
//

import Foundation

struct Messages {
    
    //---------------------- Properties ---------------
    
    var sender: String
    var body: String
    
    var type: MessageType
}

enum MessageType: String {
    case text = "TEXT"
    case image = "IMAGE"
}
