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
    
    // MARK: - Life Cycle Views
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        currentPreset = presetModelController.createPreset(context: CoreDataStack.shared.mainContext)
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowAddTimer" {
            let destination = segue.destination as! AddTimerViewController
            destination.timerModelController = timerModelController
            destination.delegate = self
        }
    }

    // MARK: - IBActions
    @IBAction func restartButtonTapped(_ sender: Any) {
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        timerController?.startTimer()
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
    
    func changeTimerDisplay(_ valueToDisplay: Int) {
        
        let timerFormatter = DateComponentsFormatter()
        let timerInterval = TimeInterval(valueToDisplay)
        
        timerFormatter.allowedUnits = [.minute, .second]
        timerFormatter.unitsStyle = .positional
        timerFormatter.zeroFormattingBehavior = .pad
        
        timerLabel.text = timerFormatter.string(from: timerInterval)
    }
    
}

extension TimerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let timer = currentPreset?.timers?[indexPath.item] as? Timer else { return }
        let timerFormatter = DateComponentsFormatter()
        let agitateTimer = DateComponentsFormatter()
        let timerInterval = TimeInterval(timer.minutesLength + timer.secondsLength)
        let agitateInterval = TimeInterval(timer.agitateTimer)
        
        timerFormatter.allowedUnits = [.minute, .second]
        timerFormatter.unitsStyle = .positional
        timerFormatter.zeroFormattingBehavior = .pad
        
        agitateTimer.allowedUnits = [.second]
        agitateTimer.unitsStyle = .spellOut
        
        let timerDisplay = timerFormatter.string(from: timerInterval)
        timerLabel.text = timerDisplay
        
        timerTitleLabel.text = timer.title
        
        guard let agitateSecondsDisplay = agitateTimer.string(from: agitateInterval) else { return }
        let agitateDisplay = "Evey \(agitateSecondsDisplay)"
        
        secondsInAgitationTimer.text = agitateDisplay
        
        timerController = DevTimer(mainTimerDuration: Int(timer.minutesLength + timer.secondsLength),
                                   agitateTimerDuration: Int(timer.agitateTimer))
        timerController?.delegate = self
    }
}

extension TimerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentPreset?.timers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimerCell", for: indexPath) as? TimerCollectionViewCell else { return UICollectionViewCell() }
        
        guard let currentTimer = currentPreset?.timers?[indexPath.item] as? Timer else { return cell }
        
        cell.timerTitleLabel.text = currentTimer.title
        
        return cell
    }
    
}

extension TimerViewController: AddTimerViewControllerDelegate {
    
    func addTimerToPreset(timer: Timer) {
        
        currentPreset?.addToTimers(timer)
        
        guard var count = currentPreset?.timers?.count else { return }
        
        if count > 0 {
            count -= 1
        }
        
        let indexPath = IndexPath(item: count, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
}

