import UIKit

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
        setupCollectionViewConstraints()
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
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - EXT UICollectionView
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

// MARK: - EXT SearchBar
extension PicturesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)

        searchDebouncerTimer?.invalidate()
        searchDebouncerTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.apiDataFetcher.fetchImages(searchString: searchText) { [weak self] (searchResult) in
                guard let fetchedPhotos = searchResult else { return }
                self?.pictures = fetchedPhotos.results
                self?.collectionView.reloadData()
            }
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

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
}
