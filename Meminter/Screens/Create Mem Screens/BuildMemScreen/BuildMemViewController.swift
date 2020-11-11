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

    var viewModel: BuildMemViewModelInput?
    var onEndThisFlow: (() -> Void)?
    
    private lazy var mem: Mem = Mem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        self.createUI()
        self.picsCollectionContainerView.delegate = self
        self.titlesCollectionContainerView.delegate = self
        self.subscribeOnBuildMemUpdate()
        self.viewModel?.getMemPics(select: 3, count: 3)
        self.viewModel?.getMemTitles(select: 3, count: 3)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.viewModel?.userDefaultsProvider.checkFor(key: .isFirstAppear) == true {
            self.wowwowEasy(#imageLiteral(resourceName: "choice"), title: "Собери мемас", message: "Картинка + выражение.\nНе спрашивай. Так надо!") {
                self.viewModel?.userDefaultsProvider.saveValue(value: false, for: .isFirstAppear)
            }
        }
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
    }
    
    private func showSendButtonIfNeeded() {
        guard self.mem.picId != nil, self.mem.titleId != nil else { return }
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .transitionFlipFromBottom, animations: {
            self.bottomPlace.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction private func sendMemAction(_ sender: UIButton) {
        self.viewModel?.sendMem(mem)
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
        self.buildTitle.isHidden = true
        
        self.buildMem.layer.shadowColor = UIColor.black.cgColor
        buildMem.layer.shadowOpacity = 1
        buildMem.layer.shadowOffset = .zero
        buildMem.layer.shadowRadius = 10
    }
}

extension BuildMemViewController: TitlesCollectionContainerViewDelegate {
    func titleDidSelect(_ titleId: Int, _ text: String) {
        self.mem.titleId = titleId
        self.buildTitle.text = text
        self.buildTitle.isHidden = false
        self.showSendButtonIfNeeded()
    }
}

extension BuildMemViewController: PicsCollectionContainerViewDelegate {
    func picsCellDidSelect(_ picId: Int, _ imageUrl: URL) {
        self.mem.picId = picId
        self.buildMem.kf.setImage(with: imageUrl)
        self.showSendButtonIfNeeded()
    }
}
