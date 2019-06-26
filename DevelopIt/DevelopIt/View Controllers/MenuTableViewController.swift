//
//  MenuTableViewController.swift
//  DevelopIt
//
//  Created by Christopher Aronson on 6/25/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit
import CoreData
import SideMenu

class MenuTableViewController: UITableViewController {

    var fetchRequest: NSFetchRequest<Preset>?
    var presets = [Preset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        SideMenuManager.defaultManager.menuPresentMode = .menuSlideIn
        
        fetchRequest = Preset.fetchRequest()
        fetchRequest?.includesPendingChanges = false
        fetchAndReload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        cell.textLabel?.text = presets[indexPath.row].title
        
        return cell
    }
    
    func fetchAndReload() {
        
        guard let fetchRequest = fetchRequest else { return }
        
        do {
            presets = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Could not fetch")
        }
    }

}
