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
                      timerLength: Int16,
                      agitateTimer: Int16,
                      context: NSManagedObjectContext) -> Timer {
        
        return Timer(title: title, timerLength: timerLength, agitateTimer: agitateTimer, context: context)
    }
    
    func delete(timer: Timer, context: NSManagedObjectContext) {
        
        context.delete(timer)
    }
    
    func update(timer: Timer, title: String?, timerLength: Int16?, agitateTimer: Int16?) {
        
        if let title = title {
            timer.title = title
        }
        
        if let timerLength = timerLength {
            timer.timerLength = timerLength
        }
        
        if let agitateTimer = agitateTimer {
            timer.agitateTimer = agitateTimer
        }
    }
    
}
