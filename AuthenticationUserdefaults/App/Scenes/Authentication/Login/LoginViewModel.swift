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
    case loginFailed = "Falha ao realizar Login! Verifica suas credencias e tente novamente."
    
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
    
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return email.range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
