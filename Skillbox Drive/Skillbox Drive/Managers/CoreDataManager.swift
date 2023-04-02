//
//  CoreDataManager.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 02.04.2023.
//

import Foundation
import CoreData


final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "SkillboxDrive")
        persistentContainer.loadPersistentStores { _, error in
            print(error?.localizedDescription ?? "")
        }
        return persistentContainer
    }()
    
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getItemFromStorage(_ id: NSManagedObjectID) -> YandexDiskItem? {
        do {
            return try viewContext.existingObject(with: id) as? YandexDiskItem
        } catch {
            print(error)
        }
        return nil
    }
    
    func saveYandexDiskItem(_ viewModel: TableViewCellViewModel) {
        let yandexDiskItem = YandexDiskItem(context: viewContext)
        yandexDiskItem.setValue(viewModel.name, forKey: "name")
        yandexDiskItem.setValue(viewModel.size, forKey: "size")
        yandexDiskItem.setValue(viewModel.preview, forKey: "preview")
        yandexDiskItem.setValue(viewModel.date, forKey: "created")
        yandexDiskItem.setValue(viewModel.mediaType, forKey: "mimeType")
        yandexDiskItem.setValue(viewModel.filePath, forKey: "filePath")
        yandexDiskItem.setValue(true, forKey: "isSavedLocally")
        
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    
    func fetchSavedFiles() -> [YandexDiskItem] {
        let request: NSFetchRequest<YandexDiskItem> = YandexDiskItem.fetchRequest()
        do {
            let files = try viewContext.fetch(request)
            return files
        } catch {
            print(error)
            return []
        }
    }
    
    
    func deleteItem(_ item: YandexDiskItem) {
        viewContext.delete(item)
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    
    
    
    
}
