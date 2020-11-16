//
//  SwipeReviewViewCell.swift
//  Meminter
//
//  Created by Дмитрий Х on 12.11.2020.
//

import UIKit
import Kingfisher

final class SwipeReviewViewCell: SwipeViewCell {
    private let imgv = UIImageView()
    private let title = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    func congigure(mem: MemModel) {
        self.imgv.kf.setImage(with: URL(string: URL.baseUrlString + mem.url))
        self.title.text = mem.title
    }
    
    private func setupUI() {
        self.addSubview(self.imgv)
        self.imgv.backgroundColor = .white
        self.imgv.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.imgv.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imgv.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imgv.widthAnchor.constraint(equalToConstant: 200),
            self.imgv.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        self.createTitle()
    }
    
    private func createTitle() {
        self.addSubview(self.title)
        self.title.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        title.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        title.backgroundColor = .black
        title.textColor = .white
        title.layer.cornerRadius = 5
        title.clipsToBounds = true
        title.textAlignment = .center
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            title.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            title.heightAnchor.constraint(greaterThanOrEqualToConstant: 25),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
}
