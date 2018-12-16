//
//  EditScreen.swift
//  AwesomeHT6Tabble
//
//  Created by Мостовий Ігор on 13.12.18.
//  Copyright © 2018 Мостовий Ігор. All rights reserved.
//

import UIKit

class EditScreen: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var isCompliteSwitch: UISwitch!
    @IBOutlet weak var lastModifiedLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    private let datePicker = UIDatePicker()
    var note: TableViewController.Note? = nil
    var lastModified: String? = nil
    private let edit: String = "Edit"
    private let save: String = "Save"
    var editedNote: ((TableViewController.Note?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.isUserInteractionEnabled = false
        descriptionTextField.isUserInteractionEnabled = false
        dateTextField.isUserInteractionEnabled = false
        isCompliteSwitch.isEnabled = false
        editButton.setTitle(edit, for: UIControl.State.normal)
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(AddScreen.dateChanged(datePicker:)), for: .valueChanged)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddScreen.recognizeTapping(gestureRecognizer:)))
        view.addGestureRecognizer(gestureRecognizer)
        
        guard let editedNote = note else { return }
        titleTextField?.text = editedNote.title
        descriptionTextField?.text = editedNote.description
        dateTextField?.text = editedNote.date
        isCompliteSwitch.isOn = editedNote.complited
        if lastModified != nil {
            lastModifiedLabel.text = lastModified!
        }
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
    
    //changing readonly to false/true and edit button to edit/save
    @IBAction func editSaveBottonChanging(_ sender: UIButton) {
        if titleTextField.isUserInteractionEnabled == false {
            editButton.setTitle(save, for: UIControl.State.normal)
            titleTextField.isUserInteractionEnabled = true
            descriptionTextField.isUserInteractionEnabled = true
            dateTextField.isUserInteractionEnabled = true
            isCompliteSwitch.isEnabled = true
        } else {
            editButton.setTitle(edit, for: UIControl.State.normal)
            titleTextField.isUserInteractionEnabled = false
            descriptionTextField.isUserInteractionEnabled = false
            dateTextField.isUserInteractionEnabled = false
            isCompliteSwitch.isEnabled = false
        }
    }
    
    //saving data
    @IBAction func saveButton(_ sender: UIButton) {
        guard let title = titleTextField?.text else { return }
        guard let description = descriptionTextField?.text else { return }
        guard let date = dateTextField?.text else { return }
        editedNote?(TableViewController.Note(title, description, date, isCompliteSwitch.isOn))
        navigationController?.popViewController(animated: true)
    }
}
