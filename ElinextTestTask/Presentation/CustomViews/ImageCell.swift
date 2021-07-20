import UIKit
import Kingfisher

final class ImageCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: ImageCell.self)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Styles.Default.of(.imageCornerRadius)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    func configure(with model: Model) {
        imageView.kf.setImage(with: model.imageURL,
                              options: [.cacheMemoryOnly,
                                        .transition(.fade(0.05))])
    }
}
