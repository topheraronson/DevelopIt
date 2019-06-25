//
//  TimerViewController.swift
//  DevelopIt
//
//  Created by Christopher Aronson on 6/24/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var timerTitleLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var secondsInAgitationTimer: UILabel!
    @IBOutlet var timerForAgitation: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Properties
    var timerController: DevTimer?
    var currentPreset: Preset?
    var presetModelController = PresetModelController()
    var timerModelController = TimerModelController()
    
    //Test Data
    let timerNames = ["Developer", "Stop", "Fix", "Rinse"]
    
    // MARK: - Life Cycle Views
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        currentPreset = presetModelController.createPreset(context: CoreDataStack.shared.mainContext)
        
        
    }

    @IBAction func restartButtonTapped(_ sender: Any) {
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
}

extension TimerViewController: DevTimerDelegate {
    
    func changeTimerDisplay(_ valueToDisplay: String) {
        timerLabel.text = valueToDisplay
    }
    
}

extension TimerViewController: UICollectionViewDelegate {
    
}

extension TimerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timerNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimerCell", for: indexPath) as? TimerCollectionViewCell else { return UICollectionViewCell() }
        
        cell.timerTitleLabel.text = timerNames[indexPath.item]
        
        return cell
    }
    
}

