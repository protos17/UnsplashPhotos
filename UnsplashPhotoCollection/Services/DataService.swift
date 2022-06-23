//
//  DataService.swift
//  UnsplashPhotoCollection
//
//  Created by Данил Чапаров on 23.06.2022.
//

import Foundation
import CoreData
import RxRelay

final class DataService {
    static let shared = DataService()
    
    let persistentContainer: NSPersistentContainer
    let dataChangePublisher = PublishRelay<Void>()
    
    init() {
        persistentContainer = NSPersistentContainer(name: "FavouriteModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                assertionFailure("Core Data failed to load \(error.localizedDescription)")
            }
        }
    }
    
    func save(_ model: PhotoModel) {
        let context: NSManagedObjectContext = {
            return self.persistentContainer.viewContext
        }()
        let savedModel = FavouriteModel(context: context)
        savedModel.id = model.id
        savedModel.createdAt = model.createdAt
        savedModel.imageUrl = model.urls.small
        savedModel.userName = model.user.name
        savedModel.userLocation = model.user.location
        savedModel.downloads = Int64(model.downloads ?? 0)
        do {
            try context.save()
            dataChangePublisher.accept(())
        } catch {
            context.rollback()
            let nserror = error as NSError
            assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func delete(for id: String) {
        let context: NSManagedObjectContext = {
            return self.persistentContainer.viewContext
        }()
        let models = getSavedModels()
        let deletedItems = models.filter({$0.id == id})
        for item in deletedItems {
            context.delete(item)
        }
        do {
            try context.save()
            dataChangePublisher.accept(())
        } catch {
            context.rollback()
            let nserror = error as NSError
            assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func checkSavedObject(_ id: String) -> Bool {
        let context: NSManagedObjectContext = {
            return self.persistentContainer.viewContext
        }()
        let fetchRequest: NSFetchRequest<FavouriteModel> = FavouriteModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let resultModel = try? context.fetch(fetchRequest)
        if let model = resultModel, !model.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func getSavedModels() -> [FavouriteModel] {
        var favouriteModels: [FavouriteModel] = .init()
        let context: NSManagedObjectContext = {
            return self.persistentContainer.viewContext
        }()
        let fetchRequest: NSFetchRequest<FavouriteModel> = FavouriteModel.fetchRequest()
        do {
            favouriteModels = try context.fetch(fetchRequest)
        } catch {
            context.rollback()
            let nserror = error as NSError
            assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return favouriteModels
    }
    
    func removeAll() {
        let context: NSManagedObjectContext = {
            return self.persistentContainer.viewContext
        }()
        do {
            let objects = getSavedModels()
            for object in objects {
                context.delete(object)
            }
            try context.save()
        } catch {
            context.rollback()
            let nserror = error as NSError
            assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
