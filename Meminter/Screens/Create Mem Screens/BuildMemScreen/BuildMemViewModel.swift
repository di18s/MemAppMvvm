//
//  BuildMemViewModel.swift
//  Meminter
//
//  Created by Дмитрий Х on 11.11.2020.
//

import Foundation

struct Mem {
    var titleId: Int?
    var picId: Int?
}

enum ReloadType {
    case titles(_ titles: [MemTitleModel])
    case pics(_ pics: [MemImageModel])
}

protocol BuildMemViewModelInput: class {
    var userDefaultsProvider: UserDefaultsProviderInput { get }
    var onError: ((String?) -> Void)? { get set }
    var onReloadData: ((ReloadType) -> Void)? { get set }
    var memTitleArray: [MemTitleModel] { get set }
    var memImageArray: [MemImageModel] { get set }
    func sendMem(_ mem: Mem)
    func getMemPics(select: Int, count: Int)
    func getMemTitles(select: Int, count: Int)
}

final class BuildMemViewModel: BuildMemViewModelInput {
    private let networkService: NetworkServiceInput
    let userDefaultsProvider: UserDefaultsProviderInput
    var memTitleArray = [MemTitleModel]() {
        didSet {
            DispatchQueue.main.async {
                self.onReloadData?(.titles(self.memTitleArray))
            }
        }
    }
    var memImageArray = [MemImageModel]() {
        didSet {
            DispatchQueue.main.async {
                self.onReloadData?(.pics(self.memImageArray))
            }
        }
    }
    var onReloadData: ((ReloadType) -> Void)?
    var onError: ((String?) -> Void)?
    
    init(networkService: NetworkServiceInput, userDefaultsProvider: UserDefaultsProviderInput) {
        self.networkService = networkService
        self.userDefaultsProvider = userDefaultsProvider
    }
    
    func getMemTitles(select: Int, count: Int) {
        self.networkService.get(.titles(select: select, count: count)) { [weak self] (titles: [MemTitleModel]?, error: String?) in
            if let error = error {
                self?.onError?(error)
            } else if let titles = titles {
                self?.memTitleArray = titles
            }
        }
    }
    
    func getMemPics(select: Int, count: Int) {
        self.networkService.get(.pics(select: select, count: count)) { [weak self] (pics: [MemImageModel]?, error: String?) in
            if let error = error {
                self?.onError?(error)
            } else if let pics = pics {
                self?.memImageArray = pics
            }
        }
    }
    
    func sendMem(_ mem: Mem) {
        guard let titleId = mem.titleId, let picId = mem.picId else { return }
        self.networkService.post(by: .mem(titleId: titleId, picId: picId)) { [weak self] error in
            self?.onError?(error)
        }
    }
}
