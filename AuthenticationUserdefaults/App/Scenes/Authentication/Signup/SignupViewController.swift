//
//  SignupViewController.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 14/02/25.
//

import UIKit

class SignupViewController: UIViewController {
    
    private let signupView = SignupView()
    
    override func loadView() {
        super.loadView()
        view = signupView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDelegatesAndDataSources()
    }
    
    private func configureNavigationBar() {
        title = "TELA DE CADASTRO"
        navigationItem.hidesBackButton = true
    }
    
    private func configureDelegatesAndDataSources() {
        signupView.delegate = self
    }
}

extension SignupViewController: SignupViewDelegate {
    func signupButtonTapped() {
        print("Clicou no botão de Cadastro")
    }
    
    func loginButtonTapped() {
        print("Voltou para a tela de Login")
    }
}
