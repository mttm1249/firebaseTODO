//
//  User.swift
//  ToDoFire
//
//  Created by Денис on 22.08.2021.
//

import Foundation
import Firebase

struct FBuser {
    
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
    
}
