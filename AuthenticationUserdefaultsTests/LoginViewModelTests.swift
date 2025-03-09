//
//  LoginViewModelTests.swift
//  AuthenticationUserdefaultsTests
//
//  Created by Diggo Silva on 08/03/25.
//

import XCTest
@testable import AuthenticationUserdefaults

class MockSuccessLogin: RepositoryProtocol {
    var users: [User] = [User(email: "email@email.com", password: "123456"), User(email: "email@ig.com", password: "123456")]
    
    func checkIfUserIsLoggedIn() -> User? {
        return users.first
    }
    
    func getUsers() -> [User] {
        return users
    }
    
    func saveUser(user: User, completion: @escaping (Result<String, SignupError>) -> Void) {} // Não é necessario
    
    func loginUser(user: User, completion: @escaping (Result<String, LoginError>) -> Void) {
        if let existingUser = users.first(where: { $0.email == user.email && $0.password == user.password }) {
            completion(.success(existingUser.email))
        } else {
            completion(.failure(.loginFailed))
        }
    }
    
    func logoutUser() {} // Não é necessario
    
    func deleteUser(user: User) {} // Não é necessario
    
    func isValidPassword(_ password: String) -> Bool {
        return password == "123456"
    }
    
    func isValidEmail(_ email: String) -> Bool {
        return email.contains("@")
    }
}

class MockFailureLogin: RepositoryProtocol {
    var users: [User] = []
    
    func checkIfUserIsLoggedIn() -> User? {
        return users.first
    }
    
    func getUsers() -> [User] {
        return users
    }
    
    func saveUser(user: User, completion: @escaping (Result<String, SignupError>) -> Void) {} // Não é necessario
    
    func loginUser(user: User, completion: @escaping (Result<String, LoginError>) -> Void) {
        completion(.failure(.loginFailed))
    }
    
    func logoutUser() {} // Não é necessario
    
    func deleteUser(user: User) {} // Não é necessario
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    func isValidEmail(_ email: String) -> Bool {
        return email.contains("@")
    }
}

final class LoginViewModelTests: XCTestCase {
    var repository: RepositoryProtocol!
    var sut: LoginViewModel!
    let validUser = User(email: "email@ig.com", password: "123456")
    
    override func setUp() {
        super.setUp()
        repository = MockSuccessLogin()
        sut = LoginViewModel(repository: repository)
    }
    
    // MARK: SUCCESS TESTS
    func testWhenEmailIsSuccessful() {
        sut.validateEmail(validUser.email) { result in
            switch result {
            case .success(let validEmail):
                XCTAssertEqual(validEmail, "email@ig.com")
            case .failure(let error):
                XCTAssertEqual(error, .invalidEmail)
            }
        }
    }
    
    func testWhenPasswordIsSuccessful() {
        sut.validatePassword(validUser.password) { result in
            switch result {
            case .success(let validPassword):
                XCTAssertEqual(validPassword, "123456")
            case .failure(let error):
                XCTAssertEqual(error, .invalidPassword)
            }
        }
    }
    
    func testWhenLoginUserIsSuccessful() {
        sut.users = [validUser]
        sut.loginUser(validUser.email, validUser.password) { result in
            switch result {
            case .success(let email):
                XCTAssertEqual(email, "email@ig.com")
            case .failure(let error):
                XCTAssertEqual(error, .loginFailed)
            }
        }
    }
    
    // MARK: FAILURE TESTS
    func testWhenEmailIsNotValid() {
        let repository = MockFailureLogin()
        let sut = LoginViewModel(repository: repository)
        
        let invalidEmail = "emailinvalido.com"
        
        sut.validateEmail(invalidEmail) { result in
            switch result {
            case .success(_):
                XCTFail("Esperado erro de email inválido, mas a validação passou")
            case .failure(let error):
                XCTAssertEqual(error, .invalidEmail)
            }
        }
    }
    
    func testWhenEmailIsEmpty() {
        let repository = MockFailureLogin()
        let sut = LoginViewModel(repository: repository)
        let emptyEmail = ""
        
        sut.validateEmail(emptyEmail) { result in
            switch result {
            case .success(_):
                XCTFail("Esperado erro de email inválido, mas a validação passou")
            case .failure(let error):
                XCTAssertEqual(error, .invalidEmail)
            }
        }
    }
    
    func testWhenEmailIsWhiteSpaces() {
        let repository = MockFailureLogin()
        let sut = LoginViewModel(repository: repository)
        let whiteSpaceEmail = " "
        
        sut.validateEmail(whiteSpaceEmail) { result in
            switch result {
            case .success(_):
                XCTFail("Esperado erro de email inválido, mas a validação passou")
            case .failure(let error):
                XCTAssertEqual(error, .invalidEmail)
            }
        }
    }
    
    func testWhenPasswordIsLessThan6Digits() {
        let repository = MockFailureLogin()
        let sut = LoginViewModel(repository: repository)
        let wrongPassword = "12345"
        
        sut.validatePassword(wrongPassword) { restul in
            switch restul {
            case .success(_):
                XCTFail("Esperado erro de senha inválida, mas a validação passou")
            case .failure(let error):
                XCTAssertEqual(error, .invalidPassword)
            }
        }
    }
    
    func testWhenLoginUserIsFailured() {
        let repository = MockFailureLogin()
        let sut = LoginViewModel(repository: repository)
        let invalidUser = User(email: "email@ig.com", password: "123456")
        
        sut.loginUser(invalidUser.email, invalidUser.password) { result in
            switch result {
            case .success(_):
                XCTFail("Esperado falha no login, mas o login foi bem-sucedido")
            case .failure(let error):
                XCTAssertEqual(error, .loginFailed)
            }
        }
    }
    
    override func tearDown() {
        repository = nil
        sut = nil
        super.tearDown()
    }
}
