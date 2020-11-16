//
//  PicsCollectionContainerView.swift
//  Meminter
//
//  Created by Дмитрий Х on 11.11.2020.
//

import UIKit
import Kingfisher

protocol PicsCollectionContainerViewDelegate: class {
    func picsCellDidSelect(_ picId: Int, _ imageURL: URL)
}

final class PicsCollectionContainerView: UIView {
    weak var delegate: PicsCollectionContainerViewDelegate?

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var heightCollectionViewAnchor: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.heightCollectionViewAnchor.constant = (self.bounds.width / 4 - 25 / 4) / 9 * 16 * 1.2
    }
    
    var pics: [MemImageModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
}

extension PicsCollectionContainerView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pic = self.pics[safe: indexPath.item], let url = URL(string: URL.baseUrlString + pic.url) else { return }
        self.delegate?.picsCellDidSelect(pic.picId, url)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.bounds.width / 4 - 25 / 4
        return CGSize(width: width, height: width / 9 * 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}

extension PicsCollectionContainerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicsCell", for: indexPath) as? PicsCell else { fatalError("Wrong titles cell class") }
        
        let imgUrl = self.pics[safe: indexPath.item]?.url ?? ""
        cell.imageView.kf.setImage(with: URL(string: URL.baseUrlString + imgUrl))
        return cell
    }
}
