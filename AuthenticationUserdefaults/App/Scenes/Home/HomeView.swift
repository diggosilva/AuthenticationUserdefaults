//
//  HomeView.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 17/02/25.
//

import UIKit

protocol HomeViewDelegate: AnyObject {
    func logoutButtonTapped()
}

class HomeView: UIView {
    lazy var welcomeLabel = buildLabel(text: "Bem Vindo, User!")
    lazy var logoutButton = buildButton(title: "Deslogar", color: .systemRed, selector: #selector(logoutButtonTapped))
    
    var email: String? {
        didSet {
            welcomeLabel.text = "Bem vindo, \(email ?? "Falha ao carregar email")"
        }
    }
    
    weak var delegate: HomeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func logoutButtonTapped() {
        delegate?.logoutButtonTapped()
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        backgroundColor = .systemBackground
        addSubviews(welcomeLabel, logoutButton)
    }
    
    private func setConstraints() {
        let padding: CGFloat = 32
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            welcomeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            logoutButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: padding / 2),
            logoutButton.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),
        ])
    }
}
