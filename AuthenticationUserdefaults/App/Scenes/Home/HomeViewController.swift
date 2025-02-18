import UIKit

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    
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
    }
    
    private func configureDelegatesAndDataSources() {
        homeView.delegate = self
    }
}

extension HomeViewController: HomeViewDelegate {
    func logoutButtonTapped() {
        print("Clicou no botão Deslogar")
    }
}
