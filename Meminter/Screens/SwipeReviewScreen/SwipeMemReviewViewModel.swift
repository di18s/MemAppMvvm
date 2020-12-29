//
//  SwipeReviewViewModel.swift
//  Meminter
//
//  Created by Дмитрий Х on 12.11.2020.
//

import Foundation
import Combine

protocol SwipeReviewViewModelInput: class {
    var mems: CurrentValueSubject<[MemModel]?, Never> { get set }
    var currentError: CurrentValueSubject<(error: String, retryAction: () -> Void)?, Never> { get set }
    
    func getMems(_ count: Int)
    func setRating(_ direction: SwipeViewSwipeDirection, id: Int)
}

final class SwipeMemReviewViewModel: SwipeReviewViewModelInput {
    private let swipeReviewService: SwipeReviewServiceInput
    private var memRequest: AnyCancellable?
    private var reviewRequest: AnyCancellable?

    var mems: CurrentValueSubject<[MemModel]?, Never> = CurrentValueSubject(nil)
    var currentError: CurrentValueSubject<(error: String, retryAction: () -> Void)?, Never> = CurrentValueSubject(nil)
    
    init(swipeReviewService: SwipeReviewServiceInput) {
        self.swipeReviewService = swipeReviewService
    }
    
    func getMems(_ count: Int) {
        let offset = self.mems.value?.count ?? 0
        let publisher: AnyPublisher<[MemModel], Error> = self.swipeReviewService.swipeReview(.mems(offset: offset, count: count, desc: true))
        self.memRequest = publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] complValue in
                switch complValue {
                case .failure(let e):
                    self?.memRequest = nil
                    self?.currentError.value = (e.localizedDescription, { [weak self] in
                        self?.getMems(count)
                    })
                case .finished:
                    self?.currentError.value = nil
                }
            }, receiveValue: { [weak self] value in
                if self?.mems.value?.isEmpty != false {
                    self?.mems.send(value)
                } else {
                    self?.mems.value?.append(contentsOf: value)
                }
            })
    }
    
    func setRating(_ direction: SwipeViewSwipeDirection, id: Int) {
        self.prefetchData(id)
        let id = self.mems.value?[id].id ?? 0
        // TODO: fix memmodel type
        let publisher: AnyPublisher<String, Error> = self.swipeReviewService.setRating(.rating(self.makeMemRating(direction), id: id))

        self.reviewRequest = publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] complValue in
                switch complValue {
                case .finished:
                    self?.currentError.value = nil
                case .failure(let e):
                    self?.reviewRequest = nil
                    self?.currentError.value = (e.localizedDescription, { [weak self] in
                        self?.setRating(direction, id: id)
                    })
                }
            }, receiveValue: { v in
                print(v)
            })
    }

    private func makeMemRating(_ direction: SwipeViewSwipeDirection) -> MemRating {
        return direction == .left ? .dislike : .like
    }

    private func prefetchData(_ index: Int) {
        if let lastMems = self.mems.value?.indices.suffix(3), lastMems.contains(index) {
            //            print("prefetch")
            self.getMems(3)
        }
    }
    
}
