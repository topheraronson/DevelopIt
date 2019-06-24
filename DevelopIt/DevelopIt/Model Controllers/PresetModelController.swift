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
    
    var presets = [Preset]()
    
    func createPreset(context: NSManagedObjectContext) -> Preset {
        
        return Preset(id: UUID(), context: context)
    }
    
    func save(preset: Preset, context: NSManagedObjectContext) {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                NSLog("\n\n\nCould not save preset.\n\n\n\(error)\n\n\n\(error.userInfo)")
            }
        }
    }
    
    func delete(preset: Preset, context: NSManagedObjectContext) {
        
        context.delete(preset)
        
        do {
            try context.save()
        } catch let error as NSError{
            NSLog("\n\n\nCould not save after deletion\n\n\n\(error)\n\n\n\(error.userInfo)")
        }
    }
    
    func update(preset: Preset, with title: String) {
        
        preset.title = title
    }
    
    func fetchAllPresets(context: NSManagedObjectContext) -> [Preset] {
        
        let fetchRequest: NSFetchRequest<Preset> = Preset.fetchRequest()
        
        do {
            presets = try context.fetch(fetchRequest)
        } catch let error as NSError {
            NSLog("\n\n\nCould not fetch from persistent store\n\n\n\(error)\n\n\n\(error.userInfo)")
        }
        
        return presets
    }
    
}
