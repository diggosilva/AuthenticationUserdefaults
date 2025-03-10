//
//  HomeViewModelTests.swift
//  AuthenticationUserdefaultsTests
//
//  Created by Diggo Silva on 09/03/25.
//

import XCTest
@testable import AuthenticationUserdefaults

class MockSuccessHome: RepositoryProtocol {
    var users: [User] = [User(email: "email@email.com", password: "123456"), User(email: "email@ig.com", password: "123456")]
    
    func checkIfUserIsLoggedIn() -> User? {
        return users.first
    }
    
    func getUsers() -> [User] {
        return users
    }
    
    func saveUser(user: User, completion: @escaping (Result<String, SignupError>) -> Void) {} // Não é necessario
    
    func loginUser(user: User, completion: @escaping (Result<String, LoginError>) -> Void) {} // Não é necessario
    
    func logoutUser() {} // Não é necessario
    
    func deleteUser(user: User) {
        users.removeAll(where: { $0.email == user.email })
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password == "123456"
    }
    
    func isValidEmail(_ email: String) -> Bool {
        return email.contains("@")
    }
}

class MockFailureHome: RepositoryProtocol {
    var users: [User] = [User(email: "email@email.com", password: "123456"), User(email: "email@ig.com", password: "123456")]
    
    func checkIfUserIsLoggedIn() -> User? {
        return users.first
    }
    
    func getUsers() -> [User] {
        return users
    }
    
    func saveUser(user: User, completion: @escaping (Result<String, SignupError>) -> Void) {} // Não é necessario
    
    func loginUser(user: User, completion: @escaping (Result<String, LoginError>) -> Void) {} // Não é necessario
    
    func logoutUser() {} // Não é necessario
    
    func deleteUser(user: User) {
        users.removeAll(where: { $0.email == user.email })
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password == "123456"
    }
    
    func isValidEmail(_ email: String) -> Bool {
        return email.contains("@")
    }
}

final class HomeViewModelTests: XCTestCase {
    var repository: RepositoryProtocol!
    var sut: HomeViewModel!
    
    override func setUp() {
        super.setUp()
        repository = MockSuccessHome()
        sut = HomeViewModel(repository: repository)
        sut.currentUser = repository.getUsers().first
    }
    
    // MARK: SUCCESS TESTS
    func testWhenLogoutUserIsSuccessful() {
        let user = sut.logoutUser()
        XCTAssertNil(user, "Usuário foi deslogado com sucesso")
    }
    
    func testWhenDeleteUserIsSuccessful() {
        // Arrange: Garantir que temos um usuário
        let userToDelete = sut.currentUser
        XCTAssertNotNil(userToDelete, "O currentUser não deve ser nulo antes de deletar.")
        
        // Act: Chamar o método deleteUser na ViewModel
        _ = sut.deleteUser()
        
        // Assert: Verificar se o currentUser foi setado como nil
        XCTAssertNil(sut.currentUser, "O currentUser deveria ser nulo após a exclusão.")
        
        // Verificar se o usuário foi realmente removido do repositório
        XCTAssertFalse(repository.getUsers().contains(where: { $0.email == userToDelete?.email }), "O usuário deveria ter sido removido do repositório.")
    }
    
    // MARK: FAILURE TESTS
    func testWhenDeleteUserIsFailureDueToNoCurrentUser() {
        sut.currentUser = nil
        
        let result = sut.deleteUser()
        XCTAssertFalse(result,"O método deleteUser deveria retornar false quando não há currentUser.")
    }
    
    override func tearDown() {
        repository = nil
        sut = nil
        super.tearDown()
    }
}
