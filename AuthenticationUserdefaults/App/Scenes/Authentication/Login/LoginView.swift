class LoginView: UIView {
    lazy var logoImageView = buildImageView(image: "envelope.fill")
    lazy var emailTextField = buildTextField(placeholder: "Email")
    lazy var passwordTextField = buildTextField(placeholder: "Senha", keyboardType: .default, isSecureTextEntry: true)
    lazy var loginButton = buildButton(title: "Logar", color: .systemBlue, selector: #selector(loginButtonTapped))
    lazy var vStack = buildStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
    lazy var signupButton = buildButtonWith2Texts(title1: "Não tem uma conta?  ", title2: "Cadastre-se!", selector: #selector(signupButtonTapped))
    lazy var spinner = buildSpinner()
    
    weak var delegate: LoginViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    @objc private func loginButtonTapped() {
        delegate?.loginButtonTapped()
    }
    
    @objc private func signupButtonTapped() {
        delegate?.signupButtonTapped()
    }
    
    private func setHierarchy() {
        backgroundColor = .secondarySystemBackground
        addSubviews(logoImageView, vStack, spinner, signupButton)
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
            
            spinner.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            
            signupButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            signupButton.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
            signupButton.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
        ])
    }
}
