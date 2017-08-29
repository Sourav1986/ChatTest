//
//  Messages+CoreDataProperties.swift
//  Chat test
//
//  Created by Sourav@Beas on 28/08/17.
//  Copyright © 2017 beas. All rights reserved.
//

import Foundation
import CoreData


extension Messages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Messages> {
        return NSFetchRequest<Messages>(entityName: "Messages")
    }

    @NSManaged public var msgid: String?
    @NSManaged public var msg: String?
    @NSManaged public var type: Int16
    @NSManaged public var message: Users?

}
