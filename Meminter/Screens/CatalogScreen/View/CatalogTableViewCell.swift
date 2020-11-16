import UIKit
import Kingfisher

final class CatalogCollectionViewCell: UICollectionViewCell {
    private var memTitle: UILabel!
    private var memImgView: UIImageView!
    private var dataTask: DownloadTask? = nil
    static var cellIdentifier = String(describing: self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
        self.createLayout()
        self.memTitle.font = UIFont.systemFont(ofSize: self.bounds.width * 0.05, weight: .bold)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.memImgView.frame = self.bounds
    }
    
    override func prepareForReuse() {
        self.dataTask?.cancel()
        self.dataTask = nil
    }
    
    func configure(_ model: MemModel) {
        self.memTitle.text = model.title
        self.dataTask = self.memImgView.kf.setImage(with: URL(string: "\(URL.baseUrlString)\(model.url)"))
    }
    
    func createUI() {
        self.memImgView = UIImageView()
        self.memImgView.backgroundColor = .white
        self.memImgView.translatesAutoresizingMaskIntoConstraints = false
        self.memImgView.contentMode = .scaleAspectFill
        self.memImgView.layer.cornerRadius = 10
        self.memImgView.clipsToBounds = true
        self.addSubview(memImgView)
        
        self.memTitle = UILabel()
        self.memTitle.translatesAutoresizingMaskIntoConstraints = false
        self.memTitle.lineBreakMode = .byWordWrapping
        self.memTitle.numberOfLines = 0
        self.memTitle.backgroundColor = .black
        self.memTitle.layer.opacity = 0.7
        self.memTitle.textColor = .white
        self.memTitle.layer.cornerRadius = 2
        self.memTitle.clipsToBounds = true
        self.memTitle.textAlignment = .center
        self.memImgView.addSubview(self.memTitle)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
    }
    
    func createLayout() {
        NSLayoutConstraint.activate([
            self.memTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.memTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            self.memTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
            self.memTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
        ])
    }
}
