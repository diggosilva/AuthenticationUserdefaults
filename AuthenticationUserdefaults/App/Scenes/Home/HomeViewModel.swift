//
//  HomeViewModel.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 17/02/25.
//

import Foundation

protocol HomeViewModelProtocol {
    func logoutUser() -> User?
    func deleteUser() -> Bool
    var currentUser: User? { get set }
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
    
    func deleteUser() -> Bool {
        guard let user = currentUser else { return false }
        currentUser = nil
        repository.deleteUser(user: user)
        return true
    }
}
