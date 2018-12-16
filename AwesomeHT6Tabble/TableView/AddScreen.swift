//
//  AddScreen.swift
//  AwesomeHT6Tabble
//
//  Created by Мостовий Ігор on 12.12.18.
//  Copyright © 2018 Мостовий Ігор. All rights reserved.
//

import UIKit

class AddScreen: UIViewController {
    @IBOutlet weak var isCompliteSwitch: UISwitch!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    private let datePicker = UIDatePicker()
    var note: TableViewController.Note? = nil
    var stadartDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isCompliteSwitch.isOn = false
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(AddScreen.dateChanged(datePicker:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        dateTextField.text = stadartDate
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddScreen.recognizeTapping(gestureRecognizer:)))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    //using for geting date from datePicker and set it to textField
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    //using for tap on screen and stop editing of anything
    @objc func recognizeTapping(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    //saving data
    var newNote: ((TableViewController.Note?) -> ())?
    @IBAction func saveButton(_ sender: UIButton) {
        guard let title = titleTextField?.text else { return }
        guard let description = descriptionTextField?.text else { return }
        guard let date = dateTextField?.text else { return }
        newNote?(TableViewController.Note(title, description, date, isCompliteSwitch.isOn))
        navigationController?.popViewController(animated: true)
    }
}
