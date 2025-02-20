//
//  LoginViewController.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 16/02/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    private let viewModel = LoginViewModel()
    
    override func loadView() {
        super.loadView()
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDelegatesAndDataSources()
    }
    
    private func configureNavigationBar() {
        title = "TELA DE LOGIN"
        navigationItem.hidesBackButton = true
    }
    
    private func configureDelegatesAndDataSources() {
        loginView.delegate = self
    }
}

extension LoginViewController: LoginViewDelegate {
    func loginButtonTapped() {
        print("Clicou no botão Logar")
        
        guard let email = loginView.emailTextField.text,
              let password = loginView.passwordTextField.text else { return }
        
        // Validar Email
        viewModel.validateEmail(email) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                showAlertError(message: error.localizedDescription)
            case .success(let validEmail):
                
                // Validar Senha
                viewModel.validatePassword(password) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .failure(let error):
                        showAlertError(message: error.localizedDescription)
                    case .success(let validPassword):
                        
                        // Logar Usuário
                        viewModel.loginUser(validEmail, validPassword) { [weak self] result in
                            guard let self = self else { return }
                            switch result {
                            case .success(let email):
                                loggedInSuccessfullyGoToHomeScreen(email: email)
                            case .failure(let error):
                                showAlertError(message: error.localizedDescription)
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
    
    private func showAlertError(message: String) {
        let alert = UIAlertController(title: "Ops... algo deu errado!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func loggedInSuccessfullyGoToHomeScreen(email: String) {
        loginView.emailTextField.text = ""
        loginView.passwordTextField.text = ""
        let homeVC = HomeViewController()
        homeVC.homeView.email = email
        navigationController?.pushViewController(homeVC, animated: true)
    }
}
