//
//  LoginViewModel.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 16/02/25.
//

import Foundation

// MARK: - Error Handling
enum LoginError: String, Error {
    case invalidEmail = "Email inválido. Ex: exemplo@dominio.com"
    case invalidPassword = "Senha inválida, deve ter no mínimo 6 caracteres"
    case loginFailed = "Falha ao realizar Login! Verifique suas credencias e tente novamente."
    
    var localizedDescription: String {
        return self.rawValue
    }
}

// MARK: - Protocol
protocol LoginViewModelProtocol {
    func checkIfUserIsLoggedIn() -> User?
    func validateEmail(_ email: String, completion: @escaping(Result<String, LoginError>) -> Void)
    func validatePassword(_ password: String, completion: @escaping(Result<String, LoginError>) -> Void)
    func loginUser(_ email: String, _ password: String, completion: @escaping(Result<String, LoginError>) -> Void)
    func loadUsers() -> Int
    func getAllUsers() -> [User]
}

// MARK: - ViewModel
class LoginViewModel: LoginViewModelProtocol {
    
    private let repository: RepositoryProtocol
    var users: [User] = []
    
    init(repository: RepositoryProtocol = Repository()) {
        self.repository = repository
    }
    
    // MARK: - User Authentication
    func checkIfUserIsLoggedIn() -> User? {
        return repository.checkIfUserIsLoggedIn()
    }
    
    func validateEmail(_ email: String, completion: @escaping(Result<String, LoginError>) -> Void) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            completion(.failure(.invalidEmail))
            return
        }
        
        guard repository.isValidEmail(email) else {
            completion(.failure(.invalidEmail))
            return
        }
        completion(.success(email))
    }
    
    func validatePassword(_ password: String, completion: @escaping(Result<String, LoginError>) -> Void) {
        guard password.count >= 6 else {
            completion(.failure(.invalidPassword))
            return
        }
        completion(.success(password))
    }
    
    func loginUser(_ email: String, _ password: String, completion: @escaping(Result<String, LoginError>) -> Void) {
        repository.loginUser(user: User(email: email, password: password)) { result in
            switch result {
            case .success(_):
                completion(.success(email))
            case .failure(_):
                completion(.failure(.loginFailed))
            }
        }
    }
    
    // MARK: - Private Helper Methods
    func loadUsers() -> Int {
        return repository.getUsers().count
    }
    
    func getAllUsers() -> [User] {
        repository.getUsers()
    }
}
