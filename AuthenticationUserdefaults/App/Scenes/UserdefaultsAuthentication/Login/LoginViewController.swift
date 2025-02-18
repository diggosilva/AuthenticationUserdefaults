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
    }
    
    func signupButtonTapped() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
}
