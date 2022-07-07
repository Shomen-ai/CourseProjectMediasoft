import UIKit
import PanModal

class PicturesViewController: UIViewController {

    var apiDataFetcher = APIDataFetcher()
    private var searchDebouncerTimer: Timer?
    private var pictures = [Pictures]()

    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setupNavigationBar()
        view.addSubview(collectionView)
        view.addSubview(spinner)
        setupCollectionViewConstraints()
//        if let waterfallLayout = collectionView.collectionViewLayout as? WaterfallLayout {
//            waterfallLayout.delegate = self
//        }
        setupSpinner()

    }
    // MARK: - Setup NavBar
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let label = UILabel()
        label.text = "Картинки"
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        navigationItem.titleView = label
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Найди свою картинку..."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    // MARK: - Setup CollectionView
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.delegate = self
        view.dataSource = self
        view.register(PicturesCollectionViewCell.self,
                      forCellWithReuseIdentifier: PicturesCollectionViewCell.reuseId)
        view.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.contentInsetAdjustmentBehavior = .automatic
        view.allowsMultipleSelection = true

        return view
    }()

    private func setupCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    // MARK: - Setup Spinner
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    private func setupSpinner() {
        spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
    }

}

// MARK: - Extension UICollectionView
extension PicturesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PicturesCollectionViewCell.reuseId,
            for: indexPath
        ) as? PicturesCollectionViewCell else {
            return .init()
        }
        cell.unsplashPicture = pictures[indexPath.item]
        return cell
    }
}

// MARK: - Extension SearchBar
extension PicturesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.spinner.startAnimating()
        searchDebouncerTimer?.invalidate()
        searchDebouncerTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.apiDataFetcher.fetchImages(searchString: searchText) { [weak self] (searchResult) in
                self?.spinner.stopAnimating()
                guard let fetchedPhotos = searchResult else { return }
                self?.pictures = fetchedPhotos.results
                self?.collectionView.reloadData()
            }
        })
    }
}

// MARK: - Extension UICollectionViewDelegateFlowLayout
extension PicturesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picture = pictures[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(picture.height) * widthPerItem / CGFloat(picture.width)
        return CGSize(width: widthPerItem, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = InfoViewController()
        let userName = pictures[indexPath.item].user.username
        let name = pictures[indexPath.item].user.name
        let profileName = "\(name)\n(\(userName))"
        let description = pictures[indexPath.item].description != nil ?
            pictures[indexPath.item].description! :
            "The author did not add a description... Т-Т"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let time = dateFormatter.date(from: pictures[indexPath.item].created_at)!
        vc.SDWGetProfileImage = pictures[indexPath.item]
        vc.SDWGetPicture = pictures[indexPath.item]
        vc.user = Info(created_at: time,
                       likes: "\(pictures[indexPath.item].likes)",
                       descrition: description,
                       profileName: profileName)
        self.presentPanModal(vc)
    }
}

// MARK: - Extension WaterfallLayoutDelegate
//    extension PicturesViewController: WaterfallLayoutDelegate {
//        func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//            let photo = pictures[indexPath.item]
//            //        print("photo.width: \(photo.width) photo.height: \(photo.height)\n")
//            return CGSize(width: photo.width, height: photo.height)
//        }
//    }
