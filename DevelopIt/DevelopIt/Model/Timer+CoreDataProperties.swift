//
//  Timer+CoreDataProperties.swift
//  DevelopIt
//
//  Created by Christopher Aronson on 6/25/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//
//

import Foundation
import CoreData


extension Timer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timer> {
        return NSFetchRequest<Timer>(entityName: "Timer")
    }

    @NSManaged public var agitateTimer: Int16
    @NSManaged public var minutesLength: Int16
    @NSManaged public var title: String?
    @NSManaged public var secondsLength: Int16
    @NSManaged public var preset: Preset?

}
