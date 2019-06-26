//
//  DevelopItTests.swift
//  DevelopItTests
//
//  Created by Christopher Aronson on 6/23/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import XCTest
import CoreData
@testable import DevelopIt

class DevelopItModelTests: XCTestCase {

    var coreDataStack: TestCoreDataStack!
    var presetModelController: PresetModelController!
    var timerModelController: TimerModelController!
    var timerController: TimerController!
    var timerDisplay: Int!
    
    override func setUp() {
        coreDataStack = TestCoreDataStack()
        presetModelController = PresetModelController()
        timerModelController = TimerModelController()
        timerDisplay = 0
    }

    override func tearDown() {
        coreDataStack = nil
        presetModelController = nil
        timerModelController = nil
        timerController = nil
        timerDisplay = nil
    }

    func testCreatePreset() {
        
        let preset = presetModelController.createPreset(context: coreDataStack.mainContext)
        
        XCTAssertNotNil(preset)
        XCTAssertNotNil(preset.title)
        XCTAssertNotNil(preset.id)
        XCTAssertTrue(preset.title == preset.id?.uuidString)
    }
    
    func testSavePreset() {
        
        let preset = presetModelController.createPreset(context: coreDataStack.mainContext)
       
        expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.mainContext)
        { notificatino in
            return true
        }
        
        presetModelController.save(preset: preset, context: coreDataStack.mainContext)
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }
    
    func testFetchAllPreset() {
        
        let preset0 = presetModelController.createPreset(context: coreDataStack.mainContext)
        let preset1 = presetModelController.createPreset(context: coreDataStack.mainContext)
        let preset2 = presetModelController.createPreset(context: coreDataStack.mainContext)
        let preset3 = presetModelController.createPreset(context: coreDataStack.mainContext)
        let preset4 = presetModelController.createPreset(context: coreDataStack.mainContext)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.mainContext)
        { notificatino in
            return true
        }
        
        presetModelController.save(preset: preset0, context: coreDataStack.mainContext)
        presetModelController.save(preset: preset1, context: coreDataStack.mainContext)
        presetModelController.save(preset: preset2, context: coreDataStack.mainContext)
        presetModelController.save(preset: preset3, context: coreDataStack.mainContext)
        presetModelController.save(preset: preset4, context: coreDataStack.mainContext)
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
        
        
        let presets = presetModelController.fetchAllPresets(context: coreDataStack.mainContext)
        
        for preset in presets {
            XCTAssertNotNil(preset.title)
            XCTAssertNotNil(preset.id)
        }
    }
    
    func testDeletePreset() {
        
        let preset0 = presetModelController.createPreset(context: coreDataStack.mainContext)
        let preset1 = presetModelController.createPreset(context: coreDataStack.mainContext)
        let preset2 = presetModelController.createPreset(context: coreDataStack.mainContext)
        let preset3 = presetModelController.createPreset(context: coreDataStack.mainContext)
        let preset4 = presetModelController.createPreset(context: coreDataStack.mainContext)
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.mainContext)
        { notificatino in
            return true
        }
        
        presetModelController.save(preset: preset0, context: coreDataStack.mainContext)
        presetModelController.save(preset: preset1, context: coreDataStack.mainContext)
        presetModelController.save(preset: preset2, context: coreDataStack.mainContext)
        presetModelController.save(preset: preset3, context: coreDataStack.mainContext)
        presetModelController.save(preset: preset4, context: coreDataStack.mainContext)
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
        
        
        
        presetModelController.delete(preset: preset2, context: coreDataStack.mainContext)
        
        let presets = presetModelController.fetchAllPresets(context: coreDataStack.mainContext)
        
        XCTAssert(presets.count == 4)
    }
    
    func testUpdatePreset() {
        
        let preset = presetModelController.createPreset(context: coreDataStack.mainContext)
        
        XCTAssertNotNil(preset)
        XCTAssertNotNil(preset.title)
        XCTAssertNotNil(preset.id)
        
        presetModelController.update(preset: preset, with: "New Title")
        
        XCTAssertTrue(preset.title == "New Title")
    }
    
    func testCreateTimer() {
        
        let timer = timerModelController.createTimer(title: "Developer",
                                                      timerLength: 180,
                                                      agitateTimer: 30,
                                                      context: coreDataStack.mainContext)
        
        XCTAssertNotNil(timer)
        XCTAssertTrue(timer.title == "Developer")
        XCTAssertTrue(timer.timerLength == 180)
        XCTAssertTrue(timer.agitateTimer == 30)
        
        
        
    }
    
    func testDeleteTimer() {
        
        let timer = timerModelController.createTimer(title: "Developer",
                                                     timerLength: 180,
                                                     agitateTimer: 30,
                                                     context: coreDataStack.mainContext)
        
        XCTAssertNotNil(timer)
        try? coreDataStack.mainContext.save()
        
        timerModelController.delete(timer: timer, context: coreDataStack.mainContext)
        
        XCTAssertTrue(coreDataStack.mainContext.hasChanges)
    }
    
    func testUpdateTimer() {
        
        let timer = timerModelController.createTimer(title: "Developer",
                                                     timerLength: 180,
                                                     agitateTimer: 30,
                                                     context: coreDataStack.mainContext)
        
        timerModelController.update(timer: timer, title: "Developer", timerLength: nil, agitateTimer: nil)
        
        XCTAssertTrue(timer.title == "Developer")
        
    }

    func testAddTimersToPreset() {
        
        let preset = presetModelController.createPreset(context: coreDataStack.mainContext)
        
        let timer0 = timerModelController.createTimer(title: "Developer",
                                                      timerLength: 180,
                                                      agitateTimer: 30,
                                                      context: coreDataStack.mainContext)
        
        let timer1 = timerModelController.createTimer(title: "Developer",
                                                      timerLength: 180,
                                                      agitateTimer: 30,
                                                      context: coreDataStack.mainContext)
        
        let timer2 = timerModelController.createTimer(title: "Developer",
                                                      timerLength: 180,
                                                      agitateTimer: 30,
                                                      context: coreDataStack.mainContext)
        
        preset.addToTimers(timer0)
        preset.addToTimers(timer1)
        preset.addToTimers(timer2)
        
        XCTAssertTrue(preset.timers?.count == 3)
        XCTAssertTrue(preset.timers!.contains(timer0))
        XCTAssertTrue(preset.timers!.contains(timer1))
        XCTAssertTrue(preset.timers!.contains(timer2))
    }
    
    func testDeleteTimerFromPreset() {
        
        let preset = presetModelController.createPreset(context: coreDataStack.mainContext)
        
        let timer0 = timerModelController.createTimer(title: "Developer",
                                                      timerLength: 180,
                                                      agitateTimer: 30,
                                                      context: coreDataStack.mainContext)
        
        let timer1 = timerModelController.createTimer(title: "Developer",
                                                      timerLength: 180,
                                                      agitateTimer: 30,
                                                      context: coreDataStack.mainContext)
        
        let randomTimer = timerModelController.createTimer(title: "Developer",
                                                           timerLength: 180,
                                                           agitateTimer: 30,
                                                           context: coreDataStack.mainContext)
        
        let timer2 = timerModelController.createTimer(title: "Developer",
                                                      timerLength: 180,
                                                      agitateTimer: 30,
                                                      context: coreDataStack.mainContext)
        
        preset.addToTimers(timer0)
        preset.addToTimers(timer1)
        preset.addToTimers(randomTimer)
        preset.addToTimers(timer2)
        
        XCTAssertTrue(preset.timers?.count == 4)
        XCTAssertTrue(preset.timers!.contains(timer0))
        XCTAssertTrue(preset.timers!.contains(timer1))
        XCTAssertTrue(preset.timers!.contains(randomTimer))
        XCTAssertTrue(preset.timers!.contains(timer2))
        
        preset.removeFromTimers(randomTimer)
        
        XCTAssertTrue(preset.timers?.count == 3)
        XCTAssertTrue(preset.timers!.contains(timer0))
        XCTAssertTrue(preset.timers!.contains(timer1))
        XCTAssertFalse(preset.timers!.contains(randomTimer))
        XCTAssertTrue(preset.timers!.contains(timer2))

    }
    
    func testCreateAsyncTimer() {
        
        timerController = TimerController(mainTimerDuration: 60, agitateTimerDuration: 10)
        
        XCTAssertNotNil(timerController)
        XCTAssertTrue(timerController.mainTimerDuration == 60)
        XCTAssertTrue(timerController.agitateTimerDuration == 10)
    }
    
    func testStartAsyncTimer() {
        
        timerController = TimerController(mainTimerDuration: 10, agitateTimerDuration: 0)
        timerController.delegate = self
        expectation(forNotification: .TimerDidFinish, object: nil) { notification in
            return true
        }
        
        
        timerController.startTimer()
        
        waitForExpectations(timeout: 15) { error in
            XCTAssertNil(error, "error should be nil")
        }
        
    }
    
    func testPauseAsyncTimer() {
        
        timerController = TimerController(mainTimerDuration: 10, agitateTimerDuration: 0)
        timerController.delegate = self
        let expectation = self.expectation(forNotification: .TimerDidFinish, object: nil) { notification in
            return true
        }
        
        expectation.isInverted = true
        
        
        timerController.startTimer()
        timerController.pauseTimer()
        
        waitForExpectations(timeout: 15) { error in
            XCTAssertNil(error, "error should be nil")
        }
    }
    
    func testResumeAsyncTimer() {
        
        timerController = TimerController(mainTimerDuration: 10, agitateTimerDuration: 0)
        timerController.delegate = self
        expectation(forNotification: .TimerDidFinish, object: nil) { notification in
            return true
        }
        
        
        timerController.startTimer()
        timerController.pauseTimer()
        timerController.resumeTimer()
        
        waitForExpectations(timeout: 15) { error in
            XCTAssertNil(error, "error should be nil")
        }
    }
    
}

extension DevelopItModelTests: TimerControllerDelegate {
    
    func changeTimerDisplay(_ valueToDisplay: String) {
        print(valueToDisplay)
    }
}
