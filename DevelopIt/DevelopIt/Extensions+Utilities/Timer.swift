//
//  Timer.swift
//  DevelopIt
//
//  Created by Christopher Aronson on 6/24/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import AsyncTimer
import AVFoundation

protocol TimerControllerDelegate: class {
    func changeTimerDisplay(_ valueToDisplay: Int)
}

class TimerController {
    
    // MARK: - Public Properties
    var mainTimerDuration: Int
    var agitateTimerDuration: Int
    weak var delegate: TimerControllerDelegate?
    var alarmSound: AVAudioPlayer?
    var agitateCounter = -1
    
    // MARK: - Private Properties
    private lazy var timer: AsyncTimer = {

        return AsyncTimer(
            interval: .seconds(1),
            times: self.mainTimerDuration,
            block: { [weak self] value in
                self?.delegate?.changeTimerDisplay(value)
                self?.agitateCounter += 1
                
                if self?.agitateCounter == self?.agitateTimerDuration {
                    let systemSound: SystemSoundID = 1016
                    AudioServicesPlaySystemSound(systemSound)
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    self?.agitateCounter = 0
                }
            }, completion: { [weak self] in
                NotificationCenter.default.post(name: .TimerDidFinish, object: nil)
                let path = Bundle.main.path(forResource: "Gentle-wake-alarm-clock.mp3", ofType: nil)!
                let url = URL(fileURLWithPath: path)
                
                do {
                    self!.alarmSound = try AVAudioPlayer(contentsOf: url)
                    self?.alarmSound?.play()
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                } catch {
                    
                }
            }
        )
    }()
    
    
    // MARK: - INIT
    init(mainTimerDuration: Int, agitateTimerDuration: Int) {
        
        self.mainTimerDuration = mainTimerDuration
        self.agitateTimerDuration = agitateTimerDuration
    }
    
    // MARK: - Timer Control Functions
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

// TODO: - Move to its own file in extensions group
extension Notification.Name {
    public static let TimerDidFinish = Notification.Name("TimerDidFinish")
    
    public static let TextFieldTextDidChange = NSNotification.Name("TextFieldTextDidChange")
}
