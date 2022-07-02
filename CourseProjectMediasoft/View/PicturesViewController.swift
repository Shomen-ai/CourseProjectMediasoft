import UIKit

class PicturesViewController: UIViewController {

    let array = [UIImage(named: "image1")!,
                 UIImage(named: "image2")!,
                 UIImage(named: "image3")!,
                 UIImage(named: "image4")!,
                 UIImage(named: "image5")!,
                 UIImage(named: "image6")!,
                 UIImage(named: "image7")!,
                 UIImage(named: "image8")!,
                 UIImage(named: "image9")!,
                 UIImage(named: "image10")!
                ]

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
        return array.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PicturesCollectionViewCell.reuseId,
            for: indexPath
        ) as? PicturesCollectionViewCell else {
            return .init()
        }
        cell.configCell(image: array[indexPath.row])
        return cell
    }
}

// MARK: - EXT SearchBar
extension PicturesViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchDebouncerTimer?.invalidate()
//
//        let timer = Timer.scheduledTimer(
//            withTimeInterval: 1.0,
//            repeats: false
//        ) { [weak self] _ in
//            self?.fireTimer()
//        }
//
//        searchDebouncerTimer = timer
//    }
//
//    private func fireTimer() {
//        if searchBar.text?.isEmpty ?? true {
//            updateState(.startScreen)
//        } else {
//            output?.search(searchBar.text ?? "")
//        }
//    }
}
