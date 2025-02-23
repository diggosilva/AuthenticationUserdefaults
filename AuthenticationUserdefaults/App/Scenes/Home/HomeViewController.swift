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
        _ = viewModel.logoutUser()
        navigationController?.popToRootViewController(animated: true)
    }
}

extension HomeViewController: HomeViewDelegate {
    func deleteButtonTapped() {
        showAlertDelete()
    }
    
    private func showAlertDelete() {
        let alert = UIAlertController(title: "", message: "Sua conta será deletada permanentemente.\nEssa ação não pode ser desfeita.", preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "Apagar Desse iPhone", style: .destructive) { action in
            self.navigationController?.popToRootViewController(animated: true)
            guard let user = self.viewModel.currentUser else { return }
            self.viewModel.deleteUser()
            print("DEBUG: A CONTA \(String(describing: user.email)) FOI DELETADA.")
        }
        alert.addAction(delete)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
