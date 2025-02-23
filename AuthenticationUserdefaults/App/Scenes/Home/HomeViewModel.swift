//
//  HomeViewModel.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 17/02/25.
//

import Foundation

enum HomeError: String, Error {
    case logoutFailed = "Falha ao realizar Logout! Tente novamente."
    
    var localizedDescription: String {
        return self.rawValue
    }
}

protocol HomeViewModelProtocol {

}

class HomeViewModel: HomeViewModelProtocol {
    
    private let repository: RepositoryProtocol
    var currentUser: User?
    
    init(repository: RepositoryProtocol = Repository()) {
        self.repository = repository
    }
    
    func logoutUser() -> User? {
        repository.logoutUser()
        return nil
    }
    
    func deleteUser() {
        guard let user = currentUser else { return }
        currentUser = nil
        repository.deleteUser(user: user)
    }
}
