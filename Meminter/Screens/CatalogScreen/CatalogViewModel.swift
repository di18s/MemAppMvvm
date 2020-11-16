//
//  CatalogViewModel.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import Foundation

enum OptionsAdditing {
    case addition, new
}

protocol CatalogViewModelInput: class {
    var onError: ((String?) -> Void)? { get set }
    var onReloadData: (() -> Void)? { get set }
    var memCatalog: [MemModel] { get set }
    func getCatalog(_ count: Int, desc: Bool, as option: OptionsAdditing)
}

final class CatalogViewModel: CatalogViewModelInput {
    let networkService: NetworkServiceInput
    var onError: ((String?) -> Void)?
    var onReloadData: (() -> Void)?
    var memCatalog = [MemModel]()
    
    private var isLoading = false
    
    init(networkService: NetworkServiceInput) {
        self.networkService = networkService
    }
    
    func getCatalog(_ count: Int, desc: Bool, as option: OptionsAdditing) {
        guard self.isLoading == false else { return }
        self.isLoading = true
        let offset = option == .new ? 0 : self.memCatalog.count
        self.networkService.get(.mems(offset: offset, count: count, desc: desc)) { [weak self] (mems: [MemModel]?, error: String?) in
            self?.isLoading = false
            
            if let mems = mems, mems.isEmpty == false {
                switch option {
                case .new:
                    self?.memCatalog = mems
                case .addition:
                    self?.memCatalog.append(contentsOf: mems)
                }
                DispatchQueue.main.async {
//                    print(self?.memCatalog.count)
                    self?.onReloadData?()
                }
            }
            DispatchQueue.main.async {
                self?.onError?(error)
            }
        }
    }
}
