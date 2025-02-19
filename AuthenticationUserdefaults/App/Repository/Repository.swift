//
//  Repository.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 14/02/25.
//

import Foundation

protocol RepositoryProtocol {
    func getUsers() -> [User]
    func saveUser(user: User, completion: @escaping(Result<String, SignupError>) -> Void)
}

class Repository: RepositoryProtocol {
    private let userDefaults = UserDefaults.standard
    private let usersKey = "usersKey"
    var users: [User] = []

    func checkIfUserIsLoggedIn() {
        
    }
    
    func getUsers() -> [User] {
        if let usersData = userDefaults.data(forKey: usersKey) {
            if let decodedUsers = try? JSONDecoder().decode([User].self, from: usersData) {
                users = decodedUsers
            }
        }
        return users
    }
    
    func saveUser(user: User, completion: @escaping(Result<String, SignupError>) -> Void) {
        var savedUsers = getUsers()
        
        if savedUsers.contains(where: { $0.email == user.email }) {
            completion(.failure(.userAlreadyExists))
            return
        }
        savedUsers.append(user)
        
        do {
            let encodedUser = try JSONEncoder().encode(savedUsers)
            userDefaults.set(encodedUser, forKey: usersKey)
            completion(.success(user.email))
        } catch {
            completion(.failure(.signupFailed))
        }
    }
    
    func loginUser() {
        
    }
    
    func logoutUser() {
        
    }
    
    func deleteUser() {
        
    }
}
