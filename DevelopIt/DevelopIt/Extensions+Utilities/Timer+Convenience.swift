//
//  Timer+Convenience.swift
//  DevelopIt
//
//  Created by Christopher Aronson on 6/23/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import CoreData

extension Timer {
    convenience init(title: String,
                     minutesLength: Int16,
                     secondsLength: Int16,
                     agitateTimer: Int16,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = title
        self.minutesLength = minutesLength
        self.secondsLength = secondsLength
        self.agitateTimer = agitateTimer
    }
}
