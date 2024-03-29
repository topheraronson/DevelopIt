//
//  AddTimerViewController.swift
//  DevelopIt
//
//  Created by Christopher Aronson on 6/24/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit

// MARK: - Delegate protocol for passing timer back to preset
protocol AddTimerViewControllerDelegate: class {
    func addTimerToPreset(timer: Timer)
    
    func updateTimer(indexPath: IndexPath, timer: Timer)
}

class AddTimerViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var timerTitleTextField: UITextField!
    @IBOutlet var minutePickerView: UIPickerView!
    @IBOutlet var secondPickerView: UIPickerView!
    @IBOutlet var agitationSecondsLabel: UILabel!
    @IBOutlet var agitationTimerSlider: UISlider!
    @IBOutlet var agitationContainerView: UIView!
    
    // MARK: - Properties
    private var minutes: Int?
    private var seconds: Int?
    weak var currentTimer: Timer?
    var indexPathForCurrentTimer: IndexPath?
    weak var timerModelController: TimerModelController?
    weak var delegate: AddTimerViewControllerDelegate?
    
    // TODO: - Clean this up...Perhaps put in another file or something?
//    private let pickerData = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
//                              "10", "11", "12", "13", "14", "15","16", "17", "18", "19",
//                              "20", "21", "22", "23", "24", "25", "26", "27", "28", "29",
//                              "30","31", "32", "33", "34", "35", "36", "37", "38", "39",
//                              "40", "41", "42", "43", "44", "45", "46", "47", "48", "49",
//                              "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
    
    let pickerData = (0...59).map { String(format: "%02d", $0) }
    
    // MARK: - Life Cycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        minutePickerView.delegate = self
        minutePickerView.dataSource = self
        secondPickerView.delegate = self
        secondPickerView.dataSource = self
        timerTitleTextField.delegate = self
        
        agitationContainerView.backgroundColor = .white
        agitationContainerView.layer.cornerRadius = 10
        agitationContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        // TODO: - Put in a seperate method
        // TODO: - Fix picker view loading issue
        if let currentTimer = currentTimer {
            
            timerTitleTextField.text = currentTimer.title
            
            let minutesIndex = Int(currentTimer.minutesLength / 60)
            minutePickerView.selectRow(minutesIndex, inComponent: 0, animated: true)
            
            let secondIndex = Int(currentTimer.secondsLength)
            secondPickerView.selectRow(secondIndex, inComponent: 0, animated: true)
            
            agitationTimerSlider.value = Float(currentTimer.agitateTimer)
            
            if agitationTimerSlider.value == 0 {
                agitationSecondsLabel.text = "No Agitation"
            } else if agitationTimerSlider.value < 2 {
                agitationSecondsLabel.text = "Every Second"
            } else {
                agitationSecondsLabel.text = "Every \(Int(agitationTimerSlider.value)) seconds"
            }
        } else {
            agitationSecondsLabel.text = "Every 30 seconds"
        }
        
        
        setupKeyboardDismissRecognizer()
        
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        for i in [1, 2] {
            minutePickerView.subviews[i].isHidden = true
            secondPickerView.subviews[i].isHidden = true
        }
    }
    
    // MARK: - Keyboard Dismissal Functoins
    func setupKeyboardDismissRecognizer() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - IBActions
    @IBAction func slider(_ sender: UISlider) {
        
        if agitationTimerSlider.value == 0 {
            agitationSecondsLabel.text = "No Agitation"
        } else if agitationTimerSlider.value < 2 {
            agitationSecondsLabel.text = "Every Second"
        } else {
            agitationSecondsLabel.text = "Every \(Int(agitationTimerSlider.value)) seconds"
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        // TODO: - Handle reciveing an empty or nil property
        guard let title = timerTitleTextField.text,
        !title.isEmpty
        else {
            let alertController = UIAlertController(title: "No Title", message: "Please Enter a Title", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default))
            
            present(alertController, animated: true)
            return
        }
        
        
        let minutes = self.minutes ?? 0
        let seconds = self.seconds ?? 0
        // TODO: - Handle picker not changing
        let minuteInterval = Int16(minutes * 60)
        let secondInterval = Int16(seconds)
        let agitateTimer = Int16(agitationTimerSlider.value)
        
        if let currentTimer = currentTimer, let timerModelController = timerModelController  {
            
            let timerToReturn = timerModelController.update(timer: currentTimer,
                                                         title: title,
                                                         minutesLength: minuteInterval,
                                                         secondsLength: secondInterval,
                                                         agitateTimer: agitateTimer)
            
            guard let indexPath = indexPathForCurrentTimer else { return }
            
            delegate?.updateTimer(indexPath: indexPath, timer: timerToReturn)
            
        } else {
            
            let timer = timerModelController!.createTimer(title: title,
                                                          minutesLength: minuteInterval,
                                                          secondsLength: secondInterval,
                                                          agitateTimer: agitateTimer,
                                                          context: CoreDataStack.shared.mainContext)
            
            delegate?.addTimerToPreset(timer: timer)
        }
        
        
        navigationController?.popToRootViewController(animated: true)
    }
}

// TODO: - Add to own file and move to extensions group
// MARK: - Picker Delegate Extension, i.e. Selection Methods
extension AddTimerViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        timerTitleTextField.resignFirstResponder()
        
        if pickerView.tag == 1 {
            minutes = Int(pickerData[row])
        } else {
            seconds = Int(pickerData[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var title = UILabel()
        if let titleView = view {
            title = titleView as! UILabel
        }
        title.font = UIFont.systemFont(ofSize: 80, weight: UIFont.Weight.bold)
        title.textColor = UIColor.white
        
        if pickerView.tag == 1 {
            title.textAlignment = .right
        } else {
            title.textAlignment = .left
        }
        title.text =  pickerData[row]
        
        
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 81.0
    }
}

// MARK: - Picker Data Source Extension, i.e. Display data methods
extension AddTimerViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[row]
    }
    
    
    
}

// MARK: - Text Field Delegate. Used for return button
extension AddTimerViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        timerTitleTextField.resignFirstResponder()
        return true
    }
}


