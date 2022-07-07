import UIKit

class AuthViewVC: UIViewController {

    let apiDatafetcher = APIDataFetcher()
    var code: String = "" {
        didSet {
            self.apiDatafetcher.fetchUserAccess(code: self.code) { [weak self] (searchResult) in
                guard let fetchedUserAccess = searchResult else { return }
                self?.pictures = fetchedPhotos.results
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(authButton)
        setupButtonConstraints()
        WebKitVC().transitioningDelegate = self
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
        present(vc, animated: true, completion: nil)
    }

    func setupButtonConstraints() {
        authButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authButton.heightAnchor.constraint(equalToConstant: 50),
            authButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            authButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
}

extension AuthViewVC: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("WebKitVc was dismissed")
        return nil
    }
}
