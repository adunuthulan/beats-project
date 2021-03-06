//
//  User.swift
//  Beats
//
//  Created by Nirav Adunuthula on 6/25/20.
//  Copyright © 2020 Nirav Adunuthula. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User {
    let uid: String
    let username: String
    
    //MARK: - Init
    init(uid:String, username:String){
        self.uid = uid
        self.username = username
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String
            else { return nil }

        self.uid = snapshot.key
        self.username = username
    }
    
    
    
}
