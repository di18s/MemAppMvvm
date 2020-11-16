//
//  TitlesCollectionContainerView.swift
//  Meminter
//
//  Created by Дмитрий Х on 11.11.2020.
//

import UIKit

protocol TitlesCollectionContainerViewDelegate: class {
    func titleDidSelect(_ titleId: Int, _ text: String)
}

final class TitlesCollectionContainerView: UIView {
    weak var delegate: TitlesCollectionContainerViewDelegate?
    
    @IBOutlet private var collectionView: UICollectionView!
    var titles: [MemTitleModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
}

extension TitlesCollectionContainerView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let title = self.titles[safe: indexPath.item] else { return }
        self.delegate?.titleDidSelect(title.titleId, title.titleName)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width / 3 - 20 / 3, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}

extension TitlesCollectionContainerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitlesCell", for: indexPath) as? TitlesCell else { fatalError("Wrong titles cell class") }
        
        cell.titleLabel.text = self.titles[indexPath.item].titleName
        return cell
    }
}
