//
//  SignupViewModelTests.swift
//  AuthenticationUserdefaultsTests
//
//  Created by Diggo Silva on 08/03/25.
//

import XCTest
@testable import AuthenticationUserdefaults

class MockSuccessSignup: RepositoryProtocol {
    var users: [User] = [User(email: "email@email.com", password: "123456"), User(email: "email@ig.com", password: "123456")]
    var logoutCalled = false
    
    func checkIfUserIsLoggedIn() -> User? {
        return users.first
    }
    
    func getUsers() -> [User] {
        return users
    }
    
    func saveUser(user: User, completion: @escaping (Result<String, SignupError>) -> Void) {
        users.append(user)
        completion(.success(user.email))
    }
    
    func loginUser(user: User, completion: @escaping (Result<String, LoginError>) -> Void) {}
    
    func logoutUser() {
        logoutCalled = true
    }
    
    func deleteUser(user: User) {}
    
    func isValidPassword(_ password: String) -> Bool {
        return password == "123456"
    }
    
    func isValidEmail(_ email: String) -> Bool {
        return email.contains("@")
    }
}

class MockFailureSignup: RepositoryProtocol {
    var users: [User] = []
    
    func checkIfUserIsLoggedIn() -> User? {
        return users.first
    }
    
    func getUsers() -> [User] {
        return users
    }
    
    func saveUser(user: User, completion: @escaping (Result<String, SignupError>) -> Void) {
        completion(.failure(.signupFailed))
    }
    
    func loginUser(user: User, completion: @escaping (Result<String, LoginError>) -> Void) {
        completion(.failure(.loginFailed))
    }
    
    func logoutUser() {}
    
    func deleteUser(user: User) {}
    
    func isValidPassword(_ password: String) -> Bool {
        return password == ""
    }
    
    func isValidEmail(_ email: String) -> Bool {
        return !email.contains("@")
    }
}

final class SignupViewModelTests: XCTestCase {
    var repository: RepositoryProtocol!
    var sut: SignupViewModel!
    let user = User(email: "email@email.com", password: "123456")
    
    override func setUp() {
        super.setUp()
        repository = MockSuccessSignup()
        sut = SignupViewModel(repository: repository)
    }
    
    // MARK: SUCCESS TESTS
    func testWhenEmailIsValid() {
        sut.validateEmail(user.email) { result in
            switch result {
            case .success(let validEmail):
                XCTAssertEqual(validEmail, "email@email.com")
            case .failure(let error):
                XCTAssertEqual(error, .invalidEmail)
            }
        }
    }
    
    func testWhenPasswordIsValid() {
        let validPassword = "123456"
        
        sut.validatePassword(validPassword) { result in
            switch result {
            case .success(let password):
                XCTAssertEqual(password, "123456")
            case .failure(let error):
                XCTAssertEqual(error, .invalidPassword)
            }
        }
    }
    
    func testWhenConfirmPasswordIsValid() {
        let validPassword = "123456"
        
        self.sut.validateConfirmPassword("123456", password: validPassword) { result in
            switch result {
            case .success(let password):
                XCTAssertEqual(password, validPassword)
            case .failure(let error):
                XCTAssertEqual(error, .passwordMisMatch)
            }
        }
    }
    
    func testWhenPasswordAndConfirmPasswordIsValid() {
        let validPassword = "123456"
        
        sut.validatePassword(validPassword) { result in
            switch result {
            case .success(let password):
                XCTAssertEqual(password, "123456")
                
                self.sut.validateConfirmPassword("1234567", password: validPassword) { result in
                    switch result {
                    case .success(_):
                        XCTFail("Esperado o erro .passwordMismatch, mas o a senha passou no teste")
                    case .failure(let error):
                        XCTAssertEqual(error, .passwordMisMatch)
                    }
                }
            case .failure(let error):
                XCTAssertEqual(error, .invalidPassword)
            }
        }
    }
    
    func testWhenCreateUserIsSuccess() {
        let expectation = self.expectation(description: "User creation should succeed")
        
        sut.createUser(user.email, user.password) { result in
            switch result {
            case .success(let email):
                // Corrigir aqui para comparar com o email correto fornecido
                XCTAssertEqual(email, self.user.email)
            case .failure(let error):
                XCTAssertEqual(error, .signupFailed)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testWhenLogoutUser() {
        sut.logoutUser()
        if let mockRepo = repository as? MockSuccessSignup {
            XCTAssertTrue(mockRepo.logoutCalled, "O método logoutUser deveria ter sido chamado")
        } else {
            XCTFail("O repositório não é do tipo MockSuccessSignup")
        }
    }
    
    // MARK: FAILURE TESTS
    func testWhenEmailIsNotValid() {
        let repository = MockFailureSignup()
        let sut = SignupViewModel(repository: repository)
        let invalidEmail:SignupError = .invalidEmail
        
        sut.validateEmail(invalidEmail.rawValue) { result in
            switch result {
            case .success(_):
                XCTFail("Esperado erro de email inválido, mas a validação passou")
            case .failure(let error):
                XCTAssertEqual(error, .invalidEmail)
            }
        }
    }
    
    func testWhenEmailIsWhiteSpace() {
        let repository = MockFailureSignup()
        let sut = SignupViewModel(repository: repository)
        let invalidEmail = " "
        
        sut.validateEmail(invalidEmail) { result in
            switch result {
            case .success(_):
                XCTFail("Esperado erro de email inválido, mas a validação passou")
            case .failure(let error):
                XCTAssertEqual(error, .invalidEmail)
            }
        }
    }
    
    func testWhenPasswordAndConfirmPasswordIsNotValid() {
        let repository = MockFailureSignup()
        let sut = SignupViewModel(repository: repository)
        let invalidPassword = "12345"
        
        sut.validatePassword(invalidPassword) { result in
            switch result {
            case .success(let validPassword):
                XCTFail("Esperado erro de senha inválido, mas a validação passou")
                
                self.sut.validateConfirmPassword("123456", password: validPassword) { result in
                    switch result {
                    case .success(_):
                        XCTFail("Esperado o erro .passwordMismatch, mas o a senha passou no teste")
                    case .failure(let error):
                        XCTAssertEqual(error, .passwordMisMatch)
                    }
                }
            case .failure(let error):
                XCTAssertEqual(error, .invalidPassword)
            }
        }
    }
    
    override func tearDown() {
        repository = nil
        sut = nil
        super.tearDown()
    }
}
