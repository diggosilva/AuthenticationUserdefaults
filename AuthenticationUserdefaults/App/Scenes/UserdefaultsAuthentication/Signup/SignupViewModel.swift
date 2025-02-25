//
//  SignupViewModel.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 14/02/25.
//

import Foundation

// MARK: - Error Handling
enum SignupError: String, Error {
    case invalidEmail = "Email inválido. Ex: exemplo@dominio.com"
    case invalidPassword = "A senha deve ter no mínimo 6 caracteres"
    case passwordMisMatch = "As senhas não coincidem, tente novamente"
    case userAlreadyExists = "Esse email já está sendo usado por outro usuário"
    case signupFailed = "Falha ao cadastrar o usuário, tente novamente"
    
    var localizedDescription: String {
        return self.rawValue
    }
}

// MARK: - Protocol
protocol SignupViewModelProtocol {
    func validateEmail(_ email: String, completion: @escaping(Result<String, SignupError>) -> Void)
    func validatePassword(_ password: String, completion: @escaping(Result<String, SignupError>) -> Void)
    func validateConfirmPassword(_ confirmPassword: String, password: String, completion: @escaping(Result<String, SignupError>) -> Void)
    func createUser(_ email: String, _ password: String, completion: @escaping(Result<String, SignupError>) -> Void)
    func logoutUser()
}

// MARK: - ViewModel
class SignupViewModel: SignupViewModelProtocol {
    
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol = Repository()) {
        self.repository = repository
    }
    
    // MARK: - User Authentication
    func validateEmail(_ email: String, completion: @escaping(Result<String, SignupError>) -> Void) {
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
    
    func validatePassword(_ password: String, completion: @escaping(Result<String, SignupError>) -> Void) {
        guard password.count >= 6 else {
            completion(.failure(.invalidPassword))
            return
        }
        completion(.success(password))
    }
    
    func validateConfirmPassword(_ confirmPassword: String, password: String, completion: @escaping(Result<String, SignupError>) -> Void) {
        guard confirmPassword == password else {
            completion(.failure(.passwordMisMatch))
            return
        }
        completion(.success(confirmPassword))
    }
    
    func createUser(_ email: String, _ password: String, completion: @escaping(Result<String, SignupError>) -> Void) {
        repository.saveUser(user: User(email: email, password: password)) { result in
            completion(result)
        }
    }
    
    // MARK: - Private Helper Methods
    func logoutUser() {
        repository.logoutUser()
    }
}
