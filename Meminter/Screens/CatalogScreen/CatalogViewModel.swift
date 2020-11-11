//
//  CatalogViewModel.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import Foundation

protocol CatalogViewModelInput: class {
    var onError: ((String?) -> Void)? { get set }
    var onReloadData: (() -> Void)? { get set }
    var memCatalog: [MemModel] { get set }
    func getCatalog(count: Int, desc: Bool)
}

final class CatalogViewModel: CatalogViewModelInput {
    let networkService: NetworkServiceInput
    var onError: ((String?) -> Void)?
    var onReloadData: (() -> Void)?
    var memCatalog = [MemModel]() {
        didSet {
            DispatchQueue.main.async {
                self.onReloadData?()
            }
        }
    }
    
    init(networkService: NetworkServiceInput) {
        self.networkService = networkService
    }
    
    func getCatalog(count: Int, desc: Bool = true) {
        self.networkService.get(.mems(offset: self.memCatalog.count, count: count, desc: desc)) { [weak self] (mems: [MemModel]?, error: String?) in
            if let mems = mems {
                self?.memCatalog.append(contentsOf: mems)
            }
            DispatchQueue.main.async {
                self?.onError?(error)
            }
        }
    }
}
