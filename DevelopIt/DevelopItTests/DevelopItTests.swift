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
    
    override func setUp() {
        coreDataStack = TestCoreDataStack()
        presetModelController = PresetModelController()
        timerModelController = TimerModelController()
    }

    override func tearDown() {
        coreDataStack = nil
        presetModelController = nil
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

}
