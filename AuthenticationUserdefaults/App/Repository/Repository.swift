//
//  Repository.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 14/02/25.
//

import Foundation

protocol RepositoryProtocol {
    func checkIfUserIsLoggedIn() -> User?
    func getUsers() -> [User]
    func saveUser(user: User, completion: @escaping(Result<String, SignupError>) -> Void)
    func loginUser(user: User, completion: @escaping(Result<String, LoginError>) -> Void)
    func logoutUser()
}

class Repository: RepositoryProtocol {
    private let userDefaults = UserDefaults.standard
    private let usersKey = "usersKey"
    private let loggedInKey = "loggedInKey" // Chave para armazenar o e-mail do usuário logado
    var users: [User] = []

    func checkIfUserIsLoggedIn() -> User? {
        // Verificar se existe um usuário logado no UserDefaults
        if let loggedInEmail = userDefaults.string(forKey: loggedInKey) {
            // Procurar o usuário pelo e-mail
            let users = getUsers()
            if let loggedInUser = users.first(where: { $0.email == loggedInEmail }) {
                return loggedInUser
            }
        }
        return nil
    }
    
    func getUsers() -> [User] {
        if let usersData = userDefaults.data(forKey: usersKey) {
            if let decodedUsers = try? JSONDecoder().decode([User].self, from: usersData) {
                return decodedUsers
            }
        }
        return []
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
    
    func loginUser(user: User, completion: @escaping(Result<String, LoginError>) -> Void) {
        let savedUsers = getUsers()
        
        if savedUsers.contains(where: { $0.email == user.email && $0.password == user.password }) {
            // Se a autenticação for bem-sucedida, armazenamos o e-mail do usuário logado
            userDefaults.set(user.email, forKey: loggedInKey)
            completion(.success(user.email))
            return
        }
        completion(.failure(.loginFailed))
    }
    
    func logoutUser() {
        // Ao deslogar, remove o e-mail armazenado no loggedInKey
        userDefaults.removeObject(forKey: loggedInKey)
    }
    
    func deleteUser() {
        
    }
}
