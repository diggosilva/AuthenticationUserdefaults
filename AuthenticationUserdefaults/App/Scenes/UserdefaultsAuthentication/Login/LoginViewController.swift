//
//  LoginViewController.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 16/02/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    private let viewModel: LoginViewModelProtocol = LoginViewModel()
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        super.loadView()
        view = loginView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.ifUserIsLoggedInGoToHome()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDelegatesAndDataSources()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearTextFields()
    }
    
    // MARK: - Configuration Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func configureNavigationBar() {
        title = "TELA DE LOGIN"
        navigationItem.hidesBackButton = true
    }
    
    private func configureDelegatesAndDataSources() {
        loginView.delegate = self
    }
    
    private func ifUserIsLoggedInGoToHome() {
        if let loggedInUser = viewModel.checkIfUserIsLoggedIn() {
            loggedInSuccessfullyGoToHomeScreen(email: loggedInUser.email)
        } else {
            print("DEBUG: TOTAL usuários CADASTRADOS: \(self.viewModel.loadUsers())")
            print("DEBUG: EMAIL dos usuários CADASTRADOS: \(self.viewModel.getAllUsers().description)")
        }
    }
    
    private func clearTextFields() {
        loginView.emailTextField.text = ""
        loginView.passwordTextField.text = ""
    }
    
    private func loggedInSuccessfullyGoToHomeScreen(email: String) {
        let currentUser = User(email: email, password: "")
        let homeVC = HomeViewController()
        homeVC.homeView.email = currentUser.email
        homeVC.viewModel.currentUser = currentUser
        navigationController?.pushViewController(homeVC, animated: true)
        clearTextFields()
    }
}

// MARK: - LoginViewDelegate Extension
extension LoginViewController: LoginViewDelegate {
    
    // MARK: Delegate Methods
    func loginButtonTapped() {        
        guard let email = loginView.emailTextField.text,
              let password = loginView.passwordTextField.text else { return }
        
        // Validar Email
        viewModel.validateEmail(email) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.showAlertError(message: error.localizedDescription)
            case .success(let validEmail):
                
                // Validar Senha
                self.viewModel.validatePassword(password) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .failure(let error):
                        self.showAlertError(message: error.localizedDescription)
                    case .success(let validPassword):
                        
                        // Logar Usuário
                        self.viewModel.loginUser(validEmail, validPassword) { [weak self] result in
                            guard let self = self else { return }
                            switch result {
                            case .success(let email):
                                self.loggedInSuccessfullyGoToHomeScreen(email: email)
                            case .failure(let error):
                                self.showAlertError(message: error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func signupButtonTapped() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    // MARK: - Helper Methods
    private func showAlertError(message: String) {
        let alert = UIAlertController(title: "Ops... algo deu errado!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
