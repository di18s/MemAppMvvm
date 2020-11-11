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

extension TitlesCollectionContainerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let title = self.titles[safe: indexPath.item] else { return }
        self.delegate?.titleDidSelect(title.titleId, title.titleName)
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
