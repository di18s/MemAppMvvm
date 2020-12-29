//
//  CatalogViewModel.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import Foundation
import Combine

enum OptionsAdditing {
    case addition, new
}

protocol CatalogViewModelInput: class {
    var memCatalogSubject: CurrentValueSubject<[MemModel]?, Never> { get }
    var currentError: CurrentValueSubject<(error: String, retryAction: () -> Void)?, Never> { get }
    func getCatalog(_ count: Int, desc: Bool, as option: OptionsAdditing)
}

final class CatalogViewModel: CatalogViewModelInput {
    let catalogService: CatalogServiceInput
    let memCatalogSubject: CurrentValueSubject<[MemModel]?, Never> = CurrentValueSubject(nil)
    let currentError: CurrentValueSubject<(error: String, retryAction: () -> Void)?, Never> = CurrentValueSubject(nil)

    private var currentRequest: AnyCancellable?
    private var isLoading = false
    
    init(catalogService: CatalogServiceInput) {
        self.catalogService = catalogService
    }

    func getCatalog(_ count: Int, desc: Bool, as option: OptionsAdditing) {
        guard self.isLoading == false else { return }

        self.isLoading = true
        self.currentRequest = nil
        let offset = option == .new ? 0 : self.memCatalogSubject.value?.count ?? 0

        let publisher: AnyPublisher<[MemModel], Error> = self.catalogService.catalog(.mems(offset: offset, count: count, desc: desc))

        self.currentRequest = publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] error in
                switch error {
                case .failure(let e):
                    self?.currentRequest = nil
                    self?.currentError.value = (e.localizedDescription, { [weak self] in
                        self?.getCatalog(count, desc: desc, as: option)
                    })
                case .finished:
                    self?.currentError.value = nil
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] value in
                switch option {
                case .addition:
                    self?.memCatalogSubject.value?.append(contentsOf: value)
                case .new:
                    self?.memCatalogSubject.send(value)
                }
            })
    }
}
