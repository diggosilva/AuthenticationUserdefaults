//
//  LoginViewModel.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 16/02/25.
//

import Foundation

enum LoginError: String, Error {
    case invalidEmail = "Email inválido. Ex: exemplo@dominio.com"
    case invalidPassword = "Senha inválida, deve ter no mínimo 6 caracteres"
    case loginFailed = "Falha ao realizar Login! Verifique suas credencias e tente novamente."
    
    var localizedDescription: String {
        return self.rawValue
    }
}

protocol LoginViewModelProtocol {

}

class LoginViewModel: LoginViewModelProtocol {
    
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol = Repository()) {
        self.repository = repository
    }
    
    func validateEmail(_ email: String, completion: @escaping(Result<String, LoginError>) -> Void) {
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
    
    func validatePassword(_ password: String, completion: @escaping(Result<String, LoginError>) -> Void) {
        guard password.count >= 6 else {
            completion(.failure(.invalidPassword))
            return
        }
        completion(.success(password))
    }
    
    func loginUser(_ email: String, _ password: String, completion: @escaping(Result<String, LoginError>) -> Void) {
        let user = User(email: email, password: password)
        repository.loginUser(user: user) { result in
            switch result {
            case .success(_):
                completion(.success(user.email))
            case .failure(let error):
                completion(.failure(.loginFailed))
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return email.range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
