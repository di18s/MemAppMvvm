//
//  SwipeReviewViewModel.swift
//  Meminter
//
//  Created by Дмитрий Х on 12.11.2020.
//

import Foundation

protocol SwipeReviewViewModelInput: class {
    var mems: [MemModel] { get set }
    var onError: ((String?) -> Void)? { get set }
    var onReloadData: (() -> Void)? { get set } 
    func getMems(_ count: Int)
    func setRating(_ direction: SwipeViewSwipeDirection, id: Int)
}

final class SwipeReviewViewModel: SwipeReviewViewModelInput {
    private let networkService: NetworkServiceInput
    var mems: [MemModel] = []
    var onError: ((String?) -> Void)?
    var onReloadData: (() -> Void)?
    
    init(networkService: NetworkServiceInput) {
        self.networkService = networkService
    }
    
    func getMems(_ count: Int) {
        self.networkService.get(.mems(offset: self.mems.count, count: count, desc: true)) { [weak self] (mems: [MemModel]?, error: String?) in
            
            if let mems = mems, mems.isEmpty == false {
                if self?.mems.isEmpty == true {
                    self?.mems = mems
                } else {
                    self?.mems += mems
                }
                DispatchQueue.main.async {
                    self?.onReloadData?()
                }
            }
            DispatchQueue.main.async {
                self?.onError?(error)
            }
        }
    }
    
    func setRating(_ direction: SwipeViewSwipeDirection, id: Int) {
        self.prefetchData(signal: id)
        self.networkService.get(.rating(self.makeMemRating(direction), id: self.mems[id].id)) { [weak self] (_: [MemModel]?, error: String?) in
            DispatchQueue.main.async {
                self?.onError?(error)
            }
        }
    }

    private func makeMemRating(_ direction: SwipeViewSwipeDirection) -> MemRating {
        return direction == .left ? .dislike : .like
    }

    private func prefetchData(signal index: Int) {
        if self.mems.indices.suffix(3).contains(index) {
//            print("prefetch")
            self.getMems(3)
        }
    }
    
}
