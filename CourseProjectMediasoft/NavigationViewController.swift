import UIKit

class NavigationViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            configureNavigationViewController(rootViewController: PicturesViewController(),
                                              title: "Картинки",
                                              itemIcon: UIImage(systemName: "photo.on.rectangle")!),
            configureNavigationViewController(rootViewController: ProfileViewController(),
                                              title: "Профиль",
                                              itemIcon: UIImage(systemName: "person.fill")!)
        ]
        tabBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    private func configureNavigationViewController(rootViewController: UIViewController,
                                                   title: String,
                                                   itemIcon: UIImage) -> UIViewController {
        let navigationViewController = UINavigationController(rootViewController: rootViewController)
        navigationViewController.tabBarItem.title = title
        navigationViewController.tabBarItem.image = itemIcon
        return navigationViewController
    }
}
