//
//  ChoiceViewController.swift
//  SimpleDrawing
//
//  Created by Дмитрий on 06/09/2019.
//  Copyright © 2019 Ivan Babkin. All rights reserved.
//

import UIKit
import Kingfisher

final class BuildMemViewController: UIViewController {
    @IBOutlet private weak var bottomPlace: NSLayoutConstraint!
    
    @IBOutlet private weak var picsCollectionContainerView: PicsCollectionContainerView!
    @IBOutlet private weak var titlesCollectionContainerView: TitlesCollectionContainerView!
    
    @IBOutlet private weak var blackDecor: UIView!
    @IBOutlet private weak var sendMem: UIButton!
    @IBOutlet private weak var buildMem: UIImageView!
    @IBOutlet private weak var buildTitle: UILabel!
    @IBOutlet private weak var sendButtonLoader: UIActivityIndicatorView!
    
    var viewModel: BuildMemViewModelInput?
    var onEndThisFlow: (() -> Void)?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        self.createUI()
        self.picsCollectionContainerView.delegate = self
        self.titlesCollectionContainerView.delegate = self
        self.subscribeOnBuildMemUpdate()
        self.viewModel?.getMemPics(select: 25, count: 25)
        self.viewModel?.getMemTitles(select: 25, count: 25)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.clear()
        self.clear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel?.didAppear()
    }
    
    
    
    private func subscribeOnBuildMemUpdate() {
        self.viewModel?.onError = { [weak self] error in
            if let error = error {
                self?.showError(title: "Error", message: error)
            } else {
                self?.onEndThisFlow?()
            }
        }
        
        self.viewModel?.onReloadData = { [weak self] type in
            switch type {
            case .pics(let pics):
                self?.picsCollectionContainerView.pics = pics
            case .titles(let titles):
                self?.titlesCollectionContainerView.titles = titles
            }
        }
        
        self.viewModel?.onShowFunnyAlert = { [weak self] in
            self?.wowwowEasy(#imageLiteral(resourceName: "choice"), title: "Собери мемас", message: "Картинка + выражение.\nНе спрашивай. Так надо!") {}
        }
        
        self.viewModel?.onShowSendButtonLoader = { [weak self] show in
            if show {
                self?.sendButtonLoader.startAnimating()
            } else {
                self?.sendButtonLoader.stopAnimating()
            }
        }
        
        self.viewModel?.onMemBuildUpdate = { [weak self] mem in
            switch mem {
            case .title(let text):
                self?.buildTitle.text = text
            case .url(let url):
                self?.buildMem.kf.setImage(with: url)
            }
        }
        
        self.viewModel?.onShowSendButton = { [weak self] show in
            guard show else { return }
            UIView.animate(withDuration: 0.3, delay: 0.3, options: .transitionFlipFromBottom, animations: {
                self?.bottomPlace.constant = 0
                self?.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    private func clear() {
        self.buildTitle.text = ""
        self.buildMem.image = nil
    }
    
    @IBAction func reloadContent(_ sender: Any) {
        self.viewModel?.reloadContent()
    }
    
    @IBAction private func sendMemAction(_ sender: UIButton) {
        self.viewModel?.sendMem()
    }
    
    func createUI() {
        self.buildTitle.lineBreakMode = .byWordWrapping
        self.buildTitle.numberOfLines = 0
        self.buildTitle.layer.opacity = 0.7
        self.buildTitle.backgroundColor = .black
        self.buildTitle.textColor = .white
        self.buildTitle.layer.cornerRadius = 5
        self.buildTitle.clipsToBounds = true
        self.buildTitle.textAlignment = .center
        
        self.buildMem.layer.shadowColor = UIColor.black.cgColor
        buildMem.layer.shadowOpacity = 1
        buildMem.layer.shadowOffset = .zero
        buildMem.layer.shadowRadius = 10
    }
}

extension BuildMemViewController: TitlesCollectionContainerViewDelegate {
    func titleDidSelect(_ titleId: Int, _ text: String) {
        self.viewModel?.selectionDidTap(.title(id: titleId, text: text))
    }
}

extension BuildMemViewController: PicsCollectionContainerViewDelegate {
    func picsCellDidSelect(_ picId: Int, _ imageUrl: URL) {
        self.viewModel?.selectionDidTap(.mem(id: picId, url: imageUrl))
    }
}
