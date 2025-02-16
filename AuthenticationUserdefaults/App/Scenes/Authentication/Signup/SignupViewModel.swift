//
//  SignupViewModel.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 14/02/25.
//

import Foundation

enum SignupError: String, Error {
    case invalidEmail = "Email inválido. Ex: exemplo@dominio.com"
    case invalidPassword = "Senha inválida, deve ter no mínimo 6 caracteres"
    case passwordMisMatch = "Senha inválida, senhas não coincidem, tente novamente"
    case userAlreadyExists = "Esse email já está sendo usado por outro usuário"
    case signupFailed = "Falha ao cadastrar o usuário, tente novamente"
    
    var localizedDescription: String {
        return self.rawValue
    }
}

protocol SignupViewModelProtocol {

}

class SignupViewModel: SignupViewModelProtocol {
    
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol = Repository()) {
        self.repository = repository
    }
    
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return email.range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
