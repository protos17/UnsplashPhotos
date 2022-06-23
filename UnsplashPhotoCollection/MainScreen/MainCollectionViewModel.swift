//
//  MainCollectionViewModel.swift
//  UnsplashPhotoCollection
//
//  Created by Данил Чапаров on 22.06.2022.
//

import Foundation
import RxSwift
import RxRelay

final class MainCollectionViewModel {
    var photoArray = BehaviorRelay<PhotoArray>(value: .init())

    private var networkService = NetworkService()
    private let disposeBag = DisposeBag()
    
    func searchPhoto(with text: String) {
        networkService.getSearchPhoto(text: text)?
            .observe(on: MainScheduler.instance)
            .map { $0.results }
            .bind(to: photoArray)
            .disposed(by: disposeBag)
    }
    
    func getRequest() {
        networkService.getRandomPhotoArray()?
            .observe(on: MainScheduler.instance)
            .bind(to: photoArray)
            .disposed(by: disposeBag)
    }
}
