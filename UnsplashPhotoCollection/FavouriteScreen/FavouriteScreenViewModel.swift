//
//  FavouriteScreenViewModel.swift
//  UnsplashPhotoCollection
//
//  Created by Данил Чапаров on 22.06.2022.
//

import Foundation
import CoreData
import RxSwift
import RxRelay

final class FavouriteScreenViewModel {
    // MARK: - Public Properties
    var controller: NSFetchedResultsController<FavouriteModel>?
    let fetchPublisher = PublishRelay<Void>()
    let disposeBag = DisposeBag()
    
    // MARK: - Private Properties
    private let dataManager = DataService.shared
    
    // MARK: - Initializers
    init() {
        fetchData()
        dataManager.dataChangePublisher
            .subscribe { [weak self] _ in
                self?.fetchData()
                self?.fetchPublisher.accept(())
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public methods
    func changeToPhotoModel(_ model: FavouriteModel) -> PhotoModel {
        let photoModel = PhotoModel(
            id: model.id,
            createdAt: model.createdAt,
            urls: UrlModel(small: model.imageUrl),
            user: User(name: model.userName, location: model.userLocation),
            downloads: Int(model.downloads))
        return photoModel
    }
    
    // MARK: - Private methods
    private func fetchData() {
        let fetchRequest = NSFetchRequest<FavouriteModel>(entityName: "FavouriteModel")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataManager.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        do {
            try controller?.performFetch()
        } catch {
            assertionFailure("Failed to fetch entities: \(error)")
        }
    }
}
