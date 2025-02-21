//
//  SignupViewController.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 14/02/25.
//

import UIKit

class SignupViewController: UIViewController {
    
    private let signupView = SignupView()
    private let viewModel: SignupViewModelProtocol = SignupViewModel()
    
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
        
        guard let email = signupView.emailTextField.text,
              let password = signupView.passwordTextField.text,
              let confirmPassword = signupView.confirmPasswordTextField.text else { return }
        
        // Validar Email
        viewModel.validateEmail(email, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                showAlertError(message: error.localizedDescription)
            case .success(let validEmail):
                
                // Validar Senha
                viewModel.validatePassword(password, completion: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .failure(let error):
                        showAlertError(message: error.localizedDescription)
                    case .success(let validPassword):
                        
                        // Validar Confirmação de Senha
                        viewModel.validateConfirmPassword(confirmPassword, password: validPassword, completion: { [weak self] result in
                            guard let self = self else { return }
                            switch result {
                            case .failure(let error):
                                showAlertError(message: error.localizedDescription)
                            case .success(let validConfirmPassword):
                                
                                // Autenticar e Deslogar usuario
                                viewModel.createUser(validEmail, validConfirmPassword) { [weak self] result in
                                    guard let self = self else { return }
                                    switch result {
                                    case .success( _):
                                        showAlertSuccess()
                                    case .failure(let error):
                                        showAlertError(message: error.localizedDescription)
                                    }
                                }
                            }
                        })
                    }
                })
            }
        })
    }
    
    func loginButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func showAlertError(message: String) {
        let alert = UIAlertController(title: "Ops... algo deu errado!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func showAlertSuccess() {
        let alert = UIAlertController(title: "Cadastrado com sucesso!", message: "Faça o login para continuar.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}
