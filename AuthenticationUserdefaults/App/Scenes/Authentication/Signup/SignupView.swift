//
//  SignupView.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 14/02/25.
//

import UIKit

protocol SignupViewDelegate: AnyObject {
    func signupButtonTapped()
    func loginButtonTapped()
}

class SignupView: UIView {
    lazy var logoImageView = buildImageView(image: "envelope")
    lazy var emailTextField = buildTextField(placeholder: "Email")
    lazy var passwordTextField = buildTextField(placeholder: "Senha", keyboardType: .default, isSecureTextEntry: true)
    lazy var confirmPasswordTextField = buildTextField(placeholder: "Confirmar senha", keyboardType: .default, isSecureTextEntry: true)
    lazy var signupButton = buildButton(title: "Cadastrar", color: .systemBlue, selector: #selector(signupButtonTapped))
    lazy var vStack = buildStackView(arrangedSubviews: [emailTextField, passwordTextField, confirmPasswordTextField, signupButton])
    lazy var loginButton = buildButtonWith2Texts(title1: "Já tem uma conta?  ", title2: "Logar!", selector: #selector(loginButtonTapped))
    lazy var spinner = buildSpinner()
    
    weak var delegate: SignupViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    @objc private func signupButtonTapped() {
        delegate?.signupButtonTapped()
    }
    
    @objc private func loginButtonTapped() {
        delegate?.loginButtonTapped()
    }
    
    private func setHierarchy() {
        backgroundColor = .secondarySystemBackground
        addSubviews(logoImageView, vStack, spinner, loginButton)
    }
    
    private func setConstraints() {
        let padding: CGFloat = 32
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            
            vStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            spinner.centerXAnchor.constraint(equalTo: signupButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: signupButton.centerYAnchor),
            
            loginButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            loginButton.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
        ])
    }
}
