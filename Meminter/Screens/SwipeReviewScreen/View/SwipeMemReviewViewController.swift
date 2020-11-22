//
//  ViewController.swift
//  SwipeView
//
//  Created by Дмитрий Х on 21.10.2020.
//

import UIKit

final class SwipeMemReviewViewController: UIViewController {
    private let viewModel: SwipeReviewViewModelInput
    private let collection = SwipeCollectionView()
    private let stubLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    
    init(viewModel: SwipeReviewViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupCollection()
        self.subscribeOnViewModelUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getMems(3)
    }
    
    func setupCollection() {
        collection.dataSource = self
        collection.delegate = self
        self.view.addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collection.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            collection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            collection.widthAnchor.constraint(equalToConstant: 200),
            collection.heightAnchor.constraint(equalToConstant: 400)
        ])
        collection.register(type: SwipeMemReviewViewCell.self)
    }
    
    private func subscribeOnViewModelUpdates() {
        self.viewModel.onError = { [weak self] error in
            guard let error = error else { return }
            self?.showError(title: "Error", message: error)
        }
        
        self.viewModel.onReloadData = { [weak self] in
            self?.collection.reloadData()
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = .lightGray
        self.stubLabel.center = self.view.center
        self.stubLabel.text = "The End"
        self.stubLabel.textAlignment = .center
        self.stubLabel.isHidden = true
        self.view.addSubview(stubLabel)
    }
}

extension SwipeMemReviewViewController: SwipeCollectionViewDataSource {
    func swipeViewCellCount() -> Int {
        return self.viewModel.mems.count
    }
    
    func swipeViewCellConfigure(_ swipeCollectionView: SwipeCollectionView, index: Int) -> SwipeViewCell {
        guard let cell = swipeCollectionView.makeCell() as? SwipeMemReviewViewCell else { fatalError("Wrong SwipeReviewViewCell class") }
        if let mem = self.viewModel.mems[safe: index] {
            cell.congigure(mem: mem)
        }
        return cell
    }
}

extension SwipeMemReviewViewController: SwipeCollectionViewDelegate {
    func didSwipe(direction: SwipeViewSwipeDirection, index: Int) {
//        print(index, direction)
        self.viewModel.setRating(direction, id: index)
    }
    
    func didOutOfCells() {
        self.stubLabel.isHidden = false
    }
}
