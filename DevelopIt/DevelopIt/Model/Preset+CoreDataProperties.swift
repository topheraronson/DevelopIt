//
//  Preset+CoreDataProperties.swift
//  
//
//  Created by Christopher Aronson on 6/24/19.
//
//

import Foundation
import CoreData


extension Preset {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Preset> {
        return NSFetchRequest<Preset>(entityName: "Preset")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var timers: NSSet?

}

// MARK: Generated accessors for timers
extension Preset {

    @objc(addTimersObject:)
    @NSManaged public func addToTimers(_ value: Timer)

    @objc(removeTimersObject:)
    @NSManaged public func removeFromTimers(_ value: Timer)

    @objc(addTimers:)
    @NSManaged public func addToTimers(_ values: NSSet)

    @objc(removeTimers:)
    @NSManaged public func removeFromTimers(_ values: NSSet)

}
