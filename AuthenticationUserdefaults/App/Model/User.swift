//
//  User.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 14/02/25.
//

import Foundation

class User: Codable, CustomStringConvertible {
    
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    var description: String {
        return email
    }
}
