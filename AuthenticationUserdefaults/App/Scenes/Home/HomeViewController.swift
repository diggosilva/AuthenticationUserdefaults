//
//  HomeViewController.swift
//  AuthenticationUserdefaults
//
//  Created by Diggo Silva on 17/02/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    let homeView = HomeView()
    let viewModel = HomeViewModel()
    
    override func loadView() {
        super.loadView()
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDelegatesAndDataSources()
    }
    
    private func configureNavigationBar() {
        title = "SEJA BEM-VINDO AO APP"
        navigationItem.hidesBackButton = true
        let barButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutTapped))
        barButton.tintColor = .systemRed
        navigationItem.rightBarButtonItem = barButton
    }
    
    private func configureDelegatesAndDataSources() {
        homeView.delegate = self
    }
    
    @objc private func logoutTapped() {
        guard viewModel.currentUser != nil else {
            print("DEBUG: Erro ao tentar se deslogar.")
            return
        }
        viewModel.logoutUser()
        navigationController?.popToRootViewController(animated: true)
    }
}

extension HomeViewController: HomeViewDelegate {
    func deleteButtonTapped() {
        print("Clicou no botão Apagar Conta")
    }
}
