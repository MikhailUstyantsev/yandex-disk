//
//  YandexDiskItem+CoreDataProperties.swift
//  Skillbox Drive
//
//  Created by Михаил on 06.04.2023.
//
//

import Foundation
import CoreData


extension YandexDiskItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<YandexDiskItem> {
        return NSFetchRequest<YandexDiskItem>(entityName: "YandexDiskItem")
    }

    @NSManaged public var created: String?
    @NSManaged public var image: Data?
    @NSManaged public var md5: String?
    @NSManaged public var mediaType: String?
    @NSManaged public var name: String?
    @NSManaged public var size: String?
    @NSManaged public var fileData: Data?

}

extension YandexDiskItem : Identifiable {

}
