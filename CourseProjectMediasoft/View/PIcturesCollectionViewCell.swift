import UIKit
import SDWebImage

class PicturesCollectionViewCell: UICollectionViewCell {

    static let reuseId = "PicturesCell"

    // MARK: - ImageView
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        image.contentMode = .scaleAspectFill
        return image
    }()

    private func setupImageView() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    func configCell(image: UIImage) {
        imageView.image = image
    }

    var unsplashPicture: Pictures! {
        didSet {
            let pictureUrl = unsplashPicture.urls["regular"]
            guard let imageUrl = pictureUrl, let url = URL(string: imageUrl) else { return }
            imageView.sd_setImage(with: url, completed: nil)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
