//
//  SignupViewModel.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 14/02/25.
//

import Foundation

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

protocol SignupViewModelProtocol {
    func validateEmail(_ email: String, completion: @escaping(Result<String, SignupError>) -> Void)
    func validatePassword(_ password: String, completion: @escaping(Result<String, SignupError>) -> Void)
    func validateConfirmPassword(_ confirmPassword: String, password: String, completion: @escaping(Result<String, SignupError>) -> Void)
    func createUser(_ email: String, _ password: String, completion: @escaping(Result<String, SignupError>) -> Void)
    func loadUsers() -> Int
}

class SignupViewModel: SignupViewModelProtocol {
    
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol = Repository()) {
        self.repository = repository
    }
    
    func validateEmail(_ email: String, completion: @escaping(Result<String, SignupError>) -> Void) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            completion(.failure(.invalidEmail))
            return
        }
        
        guard isValidEmail(email) else {
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
        let newUser = User(email: email, password: password)
        repository.saveUser(user: newUser) { result in
            switch result {
            case .success(let email):
                completion(.success(email))
            case .failure(let error):
                if error == .userAlreadyExists {
                    completion(.failure(.userAlreadyExists))
                } else {
                    completion(.failure(.signupFailed))
                }
            }
        }
    }
    
    func loadUsers() -> Int {
        return repository.getUsers().count
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return email.range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
