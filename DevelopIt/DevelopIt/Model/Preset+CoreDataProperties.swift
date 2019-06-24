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
    @NSManaged public var timers: NSOrderedSet?

}

// MARK: Generated accessors for timers
extension Preset {

    @objc(insertObject:inTimersAtIndex:)
    @NSManaged public func insertIntoTimers(_ value: Timer, at idx: Int)

    @objc(removeObjectFromTimersAtIndex:)
    @NSManaged public func removeFromTimers(at idx: Int)

    @objc(insertTimers:atIndexes:)
    @NSManaged public func insertIntoTimers(_ values: [Timer], at indexes: NSIndexSet)

    @objc(removeTimersAtIndexes:)
    @NSManaged public func removeFromTimers(at indexes: NSIndexSet)

    @objc(replaceObjectInTimersAtIndex:withObject:)
    @NSManaged public func replaceTimers(at idx: Int, with value: Timer)

    @objc(replaceTimersAtIndexes:withTimers:)
    @NSManaged public func replaceTimers(at indexes: NSIndexSet, with values: [Timer])

    @objc(addTimersObject:)
    @NSManaged public func addToTimers(_ value: Timer)

    @objc(removeTimersObject:)
    @NSManaged public func removeFromTimers(_ value: Timer)

    @objc(addTimers:)
    @NSManaged public func addToTimers(_ values: NSOrderedSet)

    @objc(removeTimers:)
    @NSManaged public func removeFromTimers(_ values: NSOrderedSet)

}
