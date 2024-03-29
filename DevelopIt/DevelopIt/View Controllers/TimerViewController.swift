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
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var agitateContainerView: UIView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var iconContainerView: UIView!
    @IBOutlet var agitationProgressBar: UIProgressView!
    
    // MARK: - Properties
    var timerController: TimerController?
    var currentPreset: Preset?
    var presetModelController = PresetModelController()
    var timerModelController = TimerModelController()
    
    // Used for the next button. Keeps track of which cell was just selected.
    var indexForRunningTimer = 0
    
    // Used to I can access the alertController text field during the naming of the preset to veryify input.
    var alertController: UIAlertController?
    
    // MARK: - Life Cycle Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        currentPreset = presetModelController.createPreset(context: CoreDataStack.shared.mainContext)
        
        setUpView()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowAddTimer" {
            
            let destination = segue.destination as! AddTimerViewController
            
            destination.timerModelController = timerModelController
            destination.delegate = self
            
        } else if segue.identifier == "ShowEditTimer" {
            
            if let indexPaths = collectionView.indexPathsForSelectedItems {
                
                let indexPath = indexPaths[0] as IndexPath
                let destination = segue.destination as! AddTimerViewController
                
                destination.currentTimer = currentPreset?.timers?[indexPath.item] as? Timer
                destination.indexPathForCurrentTimer = indexPath
                destination.timerModelController = timerModelController
                destination.delegate = self
                
            }
        } else if segue.identifier == "ShowMenu" {
            
            let navController = segue.destination as! UINavigationController
            let destination = navController.topViewController as! MenuTableViewController
            destination.delegate = self
            
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        let cells = collectionView.visibleCells as! [TimerCollectionViewCell]

        cells.forEach { cell in
            if isEditing {
                cell.shake()
            } else {
                cell.stopShaking()
            }
        }
    }
    
    // MARK: - Private Methods
    private func setUpView() {
        
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = editButtonItem
        
        agitateContainerView.backgroundColor = .white
        agitateContainerView.layer.cornerRadius = 10
        agitateContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        iconContainerView.layer.cornerRadius = 15
        iconContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        secondsInAgitationTimer.text = ""
        
        agitationProgressBar.layer.cornerRadius = 8
        agitationProgressBar.clipsToBounds = true
        agitationProgressBar.layer.sublayers![1].cornerRadius = 8
        agitationProgressBar.subviews[1].clipsToBounds = true
    }
    
    // MARK: - @objc Methods
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
        alertController?.actions[0].isEnabled = sender.text!.count > 0
    }

    // Create way of watching timer state and change image based on that
    // MARK: - IBActions
    @IBAction func restartButtonTapped(_ sender: Any) {
        timerController?.restartTimer()
        startButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        
        if timerController?.getTimerState() == TimerState.isStopped {
            timerController?.startTimer()
            startButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
            
            guard let currentTimer = currentPreset?.timers?[indexForRunningTimer - 1] as? Timer else { return }
            
            let duration = Double(currentTimer.minutesLength + currentTimer.secondsLength)
            print(duration)
            let cell = collectionView.cellForItem(at: IndexPath(item: indexForRunningTimer - 1, section: 0)) as! TimerCollectionViewCell
            cell.setAnimationState(duration: duration, animationState: .startAnimatin)
        } else if timerController?.getTimerState() == TimerState.isRunning {
            timerController?.pauseTimer()
            startButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            let cell = collectionView.cellForItem(at: IndexPath(item: indexForRunningTimer - 1, section: 0)) as! TimerCollectionViewCell
            cell.setAnimationState(duration: nil, animationState: .pauseAnimation)
        } else if timerController?.getTimerState() == TimerState.isPaused {
            timerController?.resumeTimer()
            startButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
            let cell = collectionView.cellForItem(at: IndexPath(item: indexForRunningTimer - 1, section: 0)) as! TimerCollectionViewCell
            cell.setAnimationState(duration: nil, animationState: .resumeAnimation)
        }
        

    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        if indexForRunningTimer == currentPreset?.timers?.count {
            return
        } else {
            
            let indexPath = IndexPath(item: indexForRunningTimer, section: 0)
            let previousIndexPath = IndexPath(item: indexForRunningTimer - 1, section: 0)
            guard let cell = collectionView.cellForItem(at: previousIndexPath) as? TimerCollectionViewCell else { return }
            cell.removeCircle()
            loadFromCell(indexPath: indexPath)
            
            startButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            
            agitationProgressBar.progress = 0.0
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if currentPreset?.title == currentPreset?.id?.uuidString {
            
            createAndSaveNewPreset()
            
        } else {
            
            saveAlreadyCreatedPreset()
        }
    }
    
    @IBAction func buttonTouched(_ sender: UIButton) {
        
        UIButton.animate(withDuration: 0.2, animations: {
            
            sender.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: { finish in
            
            UIButton.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform.identity
            })
        })
    }
}

extension TimerViewController: TimerControllerDelegate {
    
    func updateProgressBar(_ progress: Progress) {
        
        if secondsInAgitationTimer.text == "Never" {
            return
        } else {
            let progressFloat = Float(progress.fractionCompleted)
            agitationProgressBar.setProgress(progressFloat, animated: true)
        }

    }
    
    
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
        
        timerController?.stopTimer()
        
        startButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        
        if isEditing {
            editCell(indexPath: indexPath)
        } else {
            loadFromCell(indexPath: indexPath)
        }
    }
    
}

extension TimerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentPreset?.timers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimerCell",
                                                            for: indexPath) as? TimerCollectionViewCell
        else { return UICollectionViewCell() }
        
        guard let currentTimer = currentPreset?.timers?[indexPath.item] as? Timer else { return cell }
        
        cell.timerTitleLabel.text = currentTimer.title
        
        cell.layer.cornerRadius = 8
        
        cell.createCircle()
        
        if isEditing {
            cell.shake()
        }
        
        return cell
    }
    
}

extension TimerViewController: AddTimerViewControllerDelegate {
    
    func addTimerToPreset(timer: Timer) {
        
        currentPreset?.addToTimers(timer)

        if let count = currentPreset?.timers?.count, count > 0 {
            let indexPath = IndexPath(item: count - 1, section: 0)
            collectionView.insertItems(at: [indexPath])
            loadFromCell(indexPath: IndexPath(item: 0, section: 0))
        }
    }
    
    func updateTimer(indexPath: IndexPath, timer: Timer) {
        currentPreset?.replaceTimers(at: indexPath.item, with: timer)
        collectionView.reloadData()
    }
}

extension TimerViewController: MenuTableViewControllerDelegate {
    func load(preset: Preset) {

        if let currentPreset = currentPreset, currentPreset.title == currentPreset.id?.uuidString {
            presetModelController.delete(preset: currentPreset, context: CoreDataStack.shared.mainContext)
        }
        
        currentPreset = preset
        collectionView.reloadData()
        loadFromCell(indexPath: IndexPath(item: 0, section: 0))
    }
}

extension TimerViewController {
    
    func loadFromCell(indexPath: IndexPath) {
        
        guard let timer = currentPreset?.timers?[indexPath.item] as? Timer else { return }
        let timerFormatter = DateComponentsFormatter()
        let agitateTimer = DateComponentsFormatter()
        let timerInterval = TimeInterval(timer.minutesLength + timer.secondsLength)
        let agitateInterval = TimeInterval(timer.agitateTimer)
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        indexForRunningTimer = indexPath.item + 1
        
        timerFormatter.allowedUnits = [.minute, .second]
        timerFormatter.unitsStyle = .positional
        timerFormatter.zeroFormattingBehavior = .pad
        
        agitateTimer.allowedUnits = [.second]
        agitateTimer.unitsStyle = .spellOut
        
        let timerDisplay = timerFormatter.string(from: timerInterval)
        timerLabel.text = timerDisplay
        
        timerTitleLabel.text = timer.title
        
        guard let agitateSecondsDisplay = agitateTimer.string(from: agitateInterval) else { return }
        let agitateDisplay = "Every \(agitateSecondsDisplay)"
        
        secondsInAgitationTimer.text = agitateDisplay == "Every zero seconds" ? "Never" : agitateDisplay
        
        timerController = TimerController(mainTimerDuration: Int(timer.minutesLength + timer.secondsLength),
                                          agitateTimerDuration: Int(timer.agitateTimer))
        timerController?.delegate = self
    }
    
    func editCell(indexPath: IndexPath) {
        
        self.setEditing(false, animated: true)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { [unowned self] _ in
            
            guard let timer = self.currentPreset?.timers?[indexPath.item] else { return }
            
            self.performSegue(withIdentifier: "ShowEditTimer", sender: timer)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in
            
            if let indexPaths = self.collectionView.indexPathsForSelectedItems {
                let indexPath = indexPaths[0]
                guard let timer = self.currentPreset?.timers?[indexPath.item] as? Timer else { return }
                self.currentPreset?.removeFromTimers(timer)
                self.collectionView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func createAndSaveNewPreset() {
        
        alertController = UIAlertController(title: "Save", message: "Name Your Preset", preferredStyle: .alert)
        
        alertController?.addTextField(configurationHandler: { [weak self] (textField) -> Void in
            textField.placeholder = "Enter Preset Name"
            
            textField.addTarget(self, action: #selector(self?.alertTextFieldDidChange(_:)), for: .editingChanged)
        })
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            
            guard let presetName = self?.alertController?.textFields?[0].text,
                let currentPreset = self?.currentPreset
                else { return }
            
            self?.presetModelController.update(preset: currentPreset, with: presetName)
            self?.presetModelController.save(preset: currentPreset, context: CoreDataStack.shared.mainContext)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        saveAction.isEnabled = false
        
        alertController?.addAction(saveAction)
        alertController?.addAction(cancelAction)
        
        present(alertController!, animated: true)
    }
    
    func saveAlreadyCreatedPreset() {
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Could not save preset")
        }
    }
}
