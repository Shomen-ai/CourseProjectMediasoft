import UIKit

class AuthViewVC: UIViewController {

    let apiDatafetcher = APIDataFetcher()
    var code: String = "" {
        didSet {
            self.apiDatafetcher.fetchUserAccess(code: self.code) { (callResult) in
                guard let fetchedUserAccess = callResult else { return }
                print(fetchedUserAccess)
                APIDataFetcher().userAcсess = fetchedUserAccess
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(navBar)
        view.addSubview(authButton)
        view.addSubview(spinner)
        view.addSubview(button1)
        setupButtonConstraints()
        setupButton1Const()
        setupSpinner()
        navigationController?.tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Setup Auth Button
    lazy var authButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.cornerRadius = 25
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.setTitle("Авторизироваться при помощи Unsplash", for: .normal)
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        return button
    }()

    @objc func action(sender: UIButton!) {
        let vc = WebKitVC()
        self.present(vc, animated: true, completion: nil)
        DispatchQueue.main.async {
            self.spinner.startAnimating()
            print(APIDataFetcher().userAcсess)
            self.spinner.stopAnimating()
            self.button1.isHidden = false
            self.spinner.stopAnimating()
        }
    }

    func setupButtonConstraints() {
        authButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authButton.heightAnchor.constraint(equalToConstant: 50),
            authButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            authButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
    // MARK: - Setup Spinner
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    private func setupSpinner() {
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    lazy var button1: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.isHidden = true
        button.addTarget(self, action: #selector(action1), for: .touchUpInside)
        return button
    }()

    @objc func action1(sender: UIButton!) {
        print("button1 clicked")
        DispatchQueue.main.async {

        }
    }

    func setupButton1Const() {
        button1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button1.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Setup NavBar

    let navBar: UINavigationBar = {
        let view = UINavigationBar()
        return view
    }()
}
