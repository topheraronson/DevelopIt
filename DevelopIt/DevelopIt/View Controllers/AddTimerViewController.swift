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
}

class AddTimerViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var timerTitleTextField: UITextField!
    @IBOutlet var minutePickerView: UIPickerView!
    @IBOutlet var secondPickerView: UIPickerView!
    @IBOutlet var agitationSecondsLabel: UILabel!
    @IBOutlet var agitationTimerSlider: UISlider!
    
    // MARK: - Properties
    private var minutes: Int?
    private var seconds: Int?
    weak var timerModelController: TimerModelController?
    weak var delegate: AddTimerViewControllerDelegate?
    private let pickerData = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15",
                              "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30",
                              "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45",
                              "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        minutePickerView.delegate = self
        minutePickerView.dataSource = self
        secondPickerView.delegate = self
        secondPickerView.dataSource = self
        timerTitleTextField.delegate = self
        
        agitationSecondsLabel.text = "No Agitation"
        setupKeyboardDismissRecognizer()
        
    }
    
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
        
        guard let title = timerTitleTextField.text,
        let minutes = minutes,
        let seconds = seconds
        else { return }
        
        let timeInterval = Int16((minutes * 60) + seconds)
        let agitateTimer = Int16(agitationTimerSlider.value)
        
        let timer = timerModelController!.createTimer(title: title,
                                                      timerLength: timeInterval,
                                                      agitateTimer: agitateTimer,
                                                      context: CoreDataStack.shared.mainContext)
        
        delegate?.addTimerToPreset(timer: timer)
        
        navigationController?.popToRootViewController(animated: true)
    }
}

// TODO: - Add to own file and move to extensions group
extension AddTimerViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        timerTitleTextField.resignFirstResponder()
        
        if pickerView.tag == 1 {
            minutes = Int(pickerData[row])
        } else {
            seconds = Int(pickerData[row])
        }
    }
}

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

extension AddTimerViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        timerTitleTextField.resignFirstResponder()
        return true
    }
}

