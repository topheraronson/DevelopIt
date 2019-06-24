//
//  Timer+CoreDataProperties.swift
//  
//
//  Created by Christopher Aronson on 6/24/19.
//
//

import Foundation
import CoreData


extension Timer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timer> {
        return NSFetchRequest<Timer>(entityName: "Timer")
    }

    @NSManaged public var agitateTimer: Int16
    @NSManaged public var timerLength: Int16
    @NSManaged public var title: String?
    @NSManaged public var preset: Preset?

}
