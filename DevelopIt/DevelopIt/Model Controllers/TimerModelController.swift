//
//  TimerModelController.swift
//  DevelopItTests
//
//  Created by Christopher Aronson on 6/24/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import CoreData

class TimerModelController {
    
    func createTimer(title: String,
                      minutesLength: Int16,
                      secondsLength: Int16,
                      agitateTimer: Int16,
                      context: NSManagedObjectContext) -> Timer {
        
        return Timer(title: title, minutesLength: minutesLength, secondsLength: secondsLength, agitateTimer: agitateTimer, context: context)
    }
    
    func delete(timer: Timer, context: NSManagedObjectContext) {
        
        context.delete(timer)
    }
    
    func update(timer: Timer, title: String?, minutesLength: Int16?, secondsLength: Int16?, agitateTimer: Int16?) {
        
        if let title = title {
            timer.title = title
        }
        
        if let minutesLength = minutesLength {
            timer.minutesLength = minutesLength
        }
        
        if let secondsLength = secondsLength {
            timer.secondsLength = secondsLength
        }
        
        if let agitateTimer = agitateTimer {
            timer.agitateTimer = agitateTimer
        }
    }
    
}
