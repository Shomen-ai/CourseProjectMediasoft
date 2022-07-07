import PanModal
import UIKit

class InfoViewController: UIViewController {
    var user: Info = Info()
    var hasLoaded = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { [self] in
            nameLabel.text = user.profileName
            if user.descrition == "The author did not add a description... Т-Т" {
                descriptionLabel.font = descriptionLabel.font.italic
            }
            descriptionLabel.text = user.descrition
            likesLabel.text = user.likes

            var dateString = "\(user.created_at)"
            dateLabel.text = String(dateString.dropLast(6))
            if picture.image != nil && picture.image!.averageColor!.isDarkColor == true {
                likesLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                dateLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(scrollView)
        setupScrollViewConstraints()
        scrollView.addSubview(picture)
        scrollView.addSubview(profileImage)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(likesLabel)
        scrollView.addSubview(likeButton)
        scrollView.addSubview(dateLabel)

        setupPictureConstraints()
        setupLikesConstraint()
        setupLikeButtonConstraints()
        setupDateLabelConstraints()
        setupDescriptionLabel()
        setupProfileImageConstraints()
        setupNameLabelConstraint()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DispatchQueue.main.async { [self] in
            hasLoaded = true
            panModalSetNeedsLayoutUpdate()
            panModalTransition(to: .shortForm)
            scrollView.contentSize = CGSize(width: view.frame.width, height: 20 + picture.frame.height + 20 +
                                            descriptionLabel.frame.height + 20 + profileImage.frame.height)
        }

    }

    var shortFormHeight: PanModalHeight {
        if hasLoaded {
            return .contentHeight(20 + picture.frame.height + 20 +
                                  descriptionLabel.frame.height + 20 + profileImage.frame.height)
        }
        return .maxHeight
    }

    // MARK: - Setup Picture
    private lazy var picture: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()

    func setupPictureConstraints() {
        picture.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picture.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            picture.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            picture.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20)
        ])
    }

    var SDWGetPicture: Pictures! {
        didSet {
            let pictureUrl = SDWGetPicture.urls["small"]
            guard let imageUrl = pictureUrl, let url = URL(string: imageUrl) else { return }
            picture.sd_setImage(with: url, completed: nil)
        }
    }

    // MARK: - Setup Likes Label
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()

    func setupLikesConstraint() {
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likesLabel.trailingAnchor.constraint(equalTo: picture.trailingAnchor, constant: -20),
            likesLabel.bottomAnchor.constraint(equalTo: picture.bottomAnchor, constant: -10)
        ])
    }

    // MARK: - Setup Like Button
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        return button
    }()

    // TODO: Add Action to Like Button
    @objc func action(sender: UIButton!) {

    }

    //    func showAlert(message: String) {
    //        let alert = UIAlertController(title: "Ошибка!", message: message,
    //                                      preferredStyle: UIAlertController.Style.alert)
    //        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    //        present(alert, animated: true, completion: nil)
    //    }
    
    func setupLikeButtonConstraints() {
        NSLayoutConstraint.activate([
            likeButton.trailingAnchor.constraint(equalTo: likesLabel.leadingAnchor, constant: -10),
            likeButton.centerYAnchor.constraint(equalTo: likesLabel.centerYAnchor)
        ])
    }

    // MARK: - Setup Date Label
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()

    func setupDateLabelConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: picture.leadingAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: picture.bottomAnchor, constant: -10)
        ])
    }
    // MARK: - Setup Profile Image
    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        image.layer.cornerRadius = 50
        image.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        image.layer.borderWidth = 1
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()

    func setupProfileImageConstraints() {
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            profileImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15)
        ])
    }

    var SDWGetProfileImage: Pictures! {
        didSet {
            let pictureUrl = SDWGetProfileImage.user.profile_image["large"]
            guard let imageUrl = pictureUrl, let url = URL(string: imageUrl) else { return }
            profileImage.sd_setImage(with: url, completed: nil)
        }
    }

    // MARK: - Setup Name Label
    private lazy var nameLabel: PaddingLabel = {
        let label = PaddingLabel()
//        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20.0)

        label.bottomInset = 10.0
        label.topInset = 10.0
        label.leftInset = 20.0
        label.rightInset = 10.0

        label.layer.cornerRadius = 25
        label.layer.borderWidth = 1
        label.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 0.8956913985, green: 0.8956913985, blue: 0.8956913985, alpha: 1)
        label.layer.masksToBounds = true

        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 75).isActive = true
        return label
    }()

    func setupNameLabelConstraint() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor)
        ])
    }

    // MARK: - Setup Description Label

    private lazy var descriptionLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14.0)

        label.bottomInset = 10.0
        label.topInset = 10.0
        label.leftInset = 20.0
        label.rightInset = 10.0

        label.layer.cornerRadius = 20
        label.layer.borderWidth = 1
        label.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 0.8956913985, green: 0.8956913985, blue: 0.8956913985, alpha: 1)
        label.layer.masksToBounds = true
        return label
    }()

    func setupDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: picture.bottomAnchor, constant: 20)
        ])
    }

    // MARK: - Setup ScrollView
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        return view
    }()

    func setupScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])

    }
}

// MARK: - Extension PanModel
extension InfoViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }

    var cornerRadius: CGFloat {
        return 25
    }
}

// MARK: - Extension ScrollViewDelegate
extension InfoViewController: UIScrollViewDelegate {
}

// MARK: - Extension UIFont
extension UIFont {

    var italic: UIFont {
        return with(traits: .traitItalic)
    }

    func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }

        return UIFont(descriptor: descriptor, size: 0)
    }
}

// MARK: - Extenstion UIColor
extension UIColor {
    var isDarkColor: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum < 0.50
    }
}

// MARK: - Extenstion UIImage
extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage",
                                    parameters: [kCIInputImageKey: inputImage,
                                                kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255,
                       green: CGFloat(bitmap[1]) / 255,
                       blue: CGFloat(bitmap[2]) / 255,
                       alpha: CGFloat(bitmap[3]) / 255)
    }
}
