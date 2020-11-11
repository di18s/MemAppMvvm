//
//  ContentViewController.swift
//  pageswift
//
//  Created by Дмитрий on 04/09/2019.
//  Copyright © 2019 Dmitry. All rights reserved.
//

import UIKit

protocol IntroContentViewControllerInput: class {
    var index: Int { get set }
    func updateView(with model: IntroContentModel)
}

final class IntroContentViewController: UIViewController, IntroContentViewControllerInput {
    private var containerView = UIView()
    private var titleLabel = UILabel()
    private var imageView = UIImageView()
    private var contentLabel = UILabel()
    
    private var contentText = ""
    private var titleText = ""
    private var image: UIImage!
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
        self.createLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = image ?? UIImage(named: "start")
    }
    
    func updateView(with model: IntroContentModel) {
        self.contentText = model.contentText
        self.titleText = model.title
        self.image = UIImage(named: model.imageName)
    }
    
    private func createUI() {
        self.containerView.layer.cornerRadius = 10
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.backgroundColor = .black
        self.view.addSubview(self.containerView)

        self.imageView.contentMode = .scaleAspectFit
        self.imageView.layer.cornerRadius = 10
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.imageView)
        
        self.titleLabel.text = self.titleText
        self.titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        self.titleLabel.textColor = .white
        self.titleLabel.textAlignment = .center
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.titleLabel)
        
        self.contentLabel.text = self.contentText
        self.contentLabel.textColor = .white
        self.contentLabel.numberOfLines = 0
        self.contentLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.contentLabel.textAlignment = .center
        self.contentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.contentLabel)
    }
    
    private func createLayout() {
        NSLayoutConstraint.activate([
            self.containerView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, constant: -100),
            self.containerView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 12 / 16),
            self.containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 10),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 20),
            self.titleLabel.widthAnchor.constraint(equalTo: self.containerView.widthAnchor),
            self.contentLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 10),
            self.contentLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.contentLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            self.contentLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -40),
            self.contentLabel.widthAnchor.constraint(equalTo: self.containerView.widthAnchor),
            self.imageView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 20),
            self.imageView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -20),
            self.imageView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
        ])
    }
}
