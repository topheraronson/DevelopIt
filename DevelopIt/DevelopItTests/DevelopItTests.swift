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
    
    override func setUp() {
        coreDataStack = TestCoreDataStack()
        presetModelController = PresetModelController()
    }

    override func tearDown() {
        coreDataStack = nil
        presetModelController = nil
    }

    func testCreatePreset() {
        
        let preset = presetModelController.createPreset(context: coreDataStack.mainContext)
        
        XCTAssertNotNil(preset)
        XCTAssertTrue(preset.title == preset.id?.uuidString)
    }
    
    func testSaveTimer() {
        
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

}
