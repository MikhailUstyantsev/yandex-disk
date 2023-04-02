//
//  YandexDiskItem+CoreDataProperties.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 03.04.2023.
//
//

import Foundation
import CoreData


extension YandexDiskItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<YandexDiskItem> {
        return NSFetchRequest<YandexDiskItem>(entityName: "YandexDiskItem")
    }

    @NSManaged public var publicKey: String?
    @NSManaged public var isSavedLocally: Bool
    @NSManaged public var name: String?
    @NSManaged public var created: String?
    @NSManaged public var publicURL: String?
    @NSManaged public var originPath: String?
    @NSManaged public var modified: String?
    @NSManaged public var path: String?
    @NSManaged public var type: String?
    @NSManaged public var mimeType: String?
    @NSManaged public var preview: String?
    @NSManaged public var size: Int64

}

extension YandexDiskItem : Identifiable {

}
