//
//  DetailViewModel.swift
//  UnsplashPhotoCollection
//
//  Created by Данил Чапаров on 23.06.2022.
//

import Foundation
import RxSwift
import RxRelay

final class DetailViewModel {
    // MARK: - Public Properties
    var modelPublisher = BehaviorRelay<PhotoModel?>(value: nil)
    var isSavedPublisher = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Private Properties
    private let dataManager = DataService.shared
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init() {
        checkSavedImage()
    }
    
    // MARK: - Public methods
    func saveOrDeleteModel() {
        defer {
            checkSavedImage()
        }
        if let model = modelPublisher.value {
            if isSavedPublisher.value, let modelId = model.id {
                dataManager.delete(for: modelId)
            } else {
                dataManager.save(model)
            }
        }
    }
    
    // MARK: - Private methods
    private func checkSavedImage() {
        modelPublisher
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                if let model = model, let modelId = model.id {
                    let isSaved = self.dataManager.checkSavedObject(modelId)
                    self.isSavedPublisher.accept(isSaved)
                }
            })
            .disposed(by: disposeBag)
    }
}
