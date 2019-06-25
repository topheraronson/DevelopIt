//
//  Timer.swift
//  DevelopIt
//
//  Created by Christopher Aronson on 6/24/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import AsyncTimer

class DevTimer {
    
    var mainTimerDuration: Int
    var agitateTimerDuration: Int
    var displayTimerText: String?
    
    private lazy var timer: AsyncTimer = {
       
        return AsyncTimer(
            interval: .seconds(1),
            times: self.mainTimerDuration,
            block: { [weak self] value in
                self?.displayTimerText = value.description
            }, completion: { [weak self] in
                print("Done")
            }
        )
    }()
    
    init(mainTimerDuration: Int, agitateTimerDuration: Int) {
        
        self.mainTimerDuration = mainTimerDuration
        self.agitateTimerDuration = agitateTimerDuration
    }
    
    func startTimer() {
        print("Starting Timer")
        timer.start()
    }
    
    func pauseTimer() {
        print("Paused Timer")
        timer.pause()
    }
    
    func resumeTimer() {
        print("Timer resumed")
        timer.resume()
    }
    
    func stopTimer() {
        print("Timer stopped")
        timer.stop()
    }
    
    func restartTimer() {
        print("Timer restarted")
        timer.restart()
    }
    
    func getTimerState() -> TimerState {
        return timer.isRunning ? .isRunning : timer.isPaused ? .isPaused : .isStopped
    }
    
}
