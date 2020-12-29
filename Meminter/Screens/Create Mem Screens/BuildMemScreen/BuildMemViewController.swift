//
//  ChoiceViewController.swift
//  SimpleDrawing
//
//  Created by Дмитрий on 06/09/2019.
//  Copyright © 2019 Ivan Babkin. All rights reserved.
//

import UIKit
import Kingfisher
import Combine

final class BuildMemViewController: UIViewController {
    var viewModel: BuildMemViewModelInput?
    var onEndThisFlow: (() -> Void)?

	@IBOutlet private weak var bottomPlace: NSLayoutConstraint!

	@IBOutlet private weak var picsCollectionContainerView: PicsCollectionContainerView!
	@IBOutlet private weak var titlesCollectionContainerView: TitlesCollectionContainerView!

	@IBOutlet private weak var blackDecor: UIView!
	@IBOutlet private weak var sendMem: UIButton!
	@IBOutlet private weak var buildMem: UIImageView!
	@IBOutlet private weak var buildTitle: UILabel!
	@IBOutlet private weak var sendButtonLoader: UIActivityIndicatorView!

	private var subscriptions: Set<AnyCancellable> = []
	private var isDisplayingSendButton = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        self.createUI()
        self.picsCollectionContainerView.delegate = self
        self.titlesCollectionContainerView.delegate = self
        self.subscribeOnBuildMemUpdate()
        self.viewModel?.reloadContent()
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
		self.viewModel?.currentError
			.sink { [weak self] error in
				guard let strongSelf = self else { return }
				guard let error = error?.error else {
					guard strongSelf.isDisplayingSendButton else { return }
					strongSelf.onEndThisFlow?()
					return
				}
				strongSelf.showError(title: "Error", message: error)
			}
			.store(in: &self.subscriptions)

		self.viewModel?.memImages
			.sink { [weak self] images in
			guard let strongSelf = self else { return }
			   guard let images = images else { return }
			   strongSelf.picsCollectionContainerView.pics = images
		   }
		   .store(in: &self.subscriptions)

		self.viewModel?.memTitles
			.sink { [weak self] titles in
			guard let strongSelf = self else { return }
			   guard let titles = titles else { return }
			   strongSelf.titlesCollectionContainerView.titles = titles
		   }
		   .store(in: &self.subscriptions)

		self.viewModel?.showFunnyAlert.sink { [weak self] _ in
			self?.wowwowEasy(#imageLiteral(resourceName: "choice"), title: "Собери мемас", message: "Картинка + выражение.\nНе спрашивай. Так надо!") {}
		}
		.store(in: &self.subscriptions)

		self.viewModel?.showSendButtonLoader.sink { [weak self] show in
			if show == true {
				self?.sendButtonLoader.startAnimating()
			} else {
				self?.sendButtonLoader.stopAnimating()
			}
		}
		.store(in: &self.subscriptions)

		self.viewModel?.memBuildUpdate
			.sink { [weak self] mem in
				guard let mem = mem else { return }
				switch mem {
				case .title(let text):
					self?.buildTitle.text = text
				case .url(let url):
					self?.buildMem.kf.setImage(with: url)
				}
			}
			.store(in: &self.subscriptions)

		self.viewModel?.showSendButton
			.sink { [weak self] show in
				guard show == true else { return }
				UIView.animate(withDuration: 0.3, delay: 0.3, options: .transitionFlipFromBottom, animations: {
					self?.bottomPlace.constant = 0
					self?.view.layoutIfNeeded()
				})
			}
			.store(in: &self.subscriptions)
    }
    
    private func clear() {
        self.buildTitle.text = ""
        self.buildMem.image = nil
		self.isDisplayingSendButton = false
		self.bottomPlace.constant = -40
    }
    
    @IBAction func reloadContent(_ sender: Any) {
        self.viewModel?.reloadContent()
    }
    
    @IBAction private func sendMemAction(_ sender: UIButton) {
		self.isDisplayingSendButton = true
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
