//
//  PresetModelController.swift
//  DevelopIt
//
//  Created by Christopher Aronson on 6/24/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import CoreData

class PresetModelController {
    
    func createPreset(context: NSManagedObjectContext) -> Preset {
        
        return Preset(context: context)
    }
}
