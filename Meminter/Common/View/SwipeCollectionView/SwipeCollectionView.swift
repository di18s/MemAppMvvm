//
//  SwipeCollectionView.swift
//  SwipeView
//
//  Created by Дмитрий Х on 21.10.2020.
//

import UIKit

protocol SwipeCollectionViewDataSource: class {
    func swipeViewCellCount() -> Int
    func swipeViewCellConfigure(_ swipeCollectionView: SwipeCollectionView, index: Int) -> SwipeViewCell
    func swipeViewCellContainerIsEmpty()
}

extension SwipeCollectionViewDataSource {
    func swipeViewCellContainerIsEmpty() {}
}

protocol SwipeCollectionViewDelegate: class {
    func didSwipe(direction: SwipeViewSwipeDirection, index: Int)
    func didOutOfCells()
}

extension SwipeCollectionViewDelegate {
    func didSwipe(direction: SwipeViewSwipeDirection, index: Int) {}
    func didOutOfCells() {}
}

class SwipeCollectionView: UIView {
    weak var dataSource: SwipeCollectionViewDataSource?
    weak var delegate: SwipeCollectionViewDelegate?
    
    private var registerType = SwipeViewCell.self
    private var createdCells = 0
    
    func makeCell() -> SwipeViewCell {
        let cell = registerType.init()
        self.setupSwipeViewCell(cell)
        return cell
    }
    
    func reloadData() {
        guard let dataSource = self.dataSource else { return }
        guard dataSource.swipeViewCellCount() > 0 else {
            dataSource.swipeViewCellContainerIsEmpty()
            return
        }
        self.makeCell(dataSource)
    }
    
    private func makeCell(_ dataSource: SwipeCollectionViewDataSource) {
        if self.createdCells < 3 {
            let count = dataSource.swipeViewCellCount()
            for _ in self.createdCells..<min(3, count) {
                let cell = dataSource.swipeViewCellConfigure(self, index: self.createdCells)
                cell.tag = self.createdCells
                self.createdCells += 1
                cell.onSwipeAction = { [weak self] direction, index in
                    self?.delegate?.didSwipe(direction: direction, index: index)
                    self?.makeCell(dataSource)
                }
            }
        } else {
            if self.createdCells < dataSource.swipeViewCellCount() {
                let cell = dataSource.swipeViewCellConfigure(self, index: self.createdCells)
                cell.tag = self.createdCells
                self.createdCells += 1
                cell.onSwipeAction = { [weak self] direction, index in
                    self?.delegate?.didSwipe(direction: direction, index: index)
                    self?.makeCell(dataSource)
                }
            } else {
                self.delegate?.didOutOfCells()
            }
        }
    }
    
    func register(type: SwipeViewCell.Type) {
        self.registerType = type
    }
    
    private func setupSwipeViewCell(_ cell: SwipeViewCell) {
        self.insertSubview(cell, at: 0)
        self.layoutIfNeeded()
        cell.frame = self.bounds
    }
}
