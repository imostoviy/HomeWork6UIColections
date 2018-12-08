//
//  TableViewController.swift
//  AwesomeHT6Tabble
//
//  Created by Мостовий Ігор on 06.12.18.
//  Copyright © 2018 Мостовий Ігор. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    struct Note {
        var title: String
        var description: String
        
        init(_ title: String, _ description: String) {
            self.title = title
            self.description = description
        }
    }
    var sectionOne: [Note] = [Note("Dictionary", "intent - намір"),
                              Note("582 Заправка", "Some text"),
                              Note("Some title three", "Some text"),
                              Note("Some title four", "Some text"),
                              Note("Some title five", "Some text"),
                              Note("some title six", "Some text"),
                              Note("Some title seven", "Some text"),
                              ]
    var sectionTwo: [Note] = [Note("Section two", "test")]
    let sectionsNames: [String] = ["Section one", "Section two"]
    let unlock: String = "відімкнено"
    var date: String = ""
    
    //it is a tap on button and adding a cell using alert
    @IBAction func addButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Add row", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(titleFied) in
            titleFied.placeholder = "Some title" })
        alert.addTextField(configurationHandler: {(decriptionField) in
            decriptionField.placeholder = "Some title" })
        let action = UIAlertAction(title: "Add", style: .default, handler: { (_) in
            guard let title = alert.textFields?.first?.text else { return }
            guard let description = alert.textFields?.last?.text else { return }
            self.add(title, description)
        })
        
        alert.addAction(action)
        present(alert, animated: true)
        tableView.reloadData()
    }
    
    // its a cool way to add a cell
    func add(_ title: String, _ description: String) {
        let index = 0
        sectionOne.insert(TableViewController.Note(title, description), at: index)
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .left)
    }
    
    //deleting cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        switch indexPath.section {
        case 0:
            sectionOne.remove(at: indexPath.row)
        default:
            sectionTwo.remove(at: indexPath.row)
        }
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tmpForDate = Date()
        let formatter = DateFormatter()
        let ordinaryCell = UINib(nibName: "OrdinaryTableViewCell", bundle: nil)
        let withLockCell = UINib(nibName: "WithLockTableViewCell", bundle: nil)
        
        tableView.register(ordinaryCell, forCellReuseIdentifier: OrdinaryTableViewCell.reuseIdentifier)
        tableView.register(withLockCell, forCellReuseIdentifier: WithLockTableViewCell.reuseIdentifier)
        formatter.dateFormat = "dd.MM.yyyy"
        self.date = formatter.string(from: tmpForDate)
        
    }
}

//MARK: - UITableViewDataSource ad UITableViewDelegat extention to class
extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    //Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sectionOne.count
        default:
            return sectionTwo.count
        }
    }
    
    //Checing if cell is nil. If not return cell else return cell with labels eroor
    func checkIfNil(_ cell: UITableViewCell?, indexPath: IndexPath) -> UITableViewCell {
        guard let ret = cell else {
            let error = tableView.dequeueReusableCell(withIdentifier: OrdinaryTableViewCell.reuseIdentifier, for: indexPath)
            (error as? OrdinaryTableViewCell)?.dateLabel.text = "error"
            (error as? OrdinaryTableViewCell)?.descriptionLabel.text = "error"
            (error as? OrdinaryTableViewCell)?.titleLabel.text = "error"
            return error
        }
        return ret
    }
    
    //creating cells for rows in sections
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 1, 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: WithLockTableViewCell.reuseIdentifier, for: indexPath) as? WithLockTableViewCell
                cell?.dateLabel.text = date
                cell?.descriptionLabel.text = unlock
                cell?.titleLabel.text = sectionOne[indexPath.row].title
                cell?.textChanged = {[weak self] (isChanged) in
                    guard let self = self else { return }
                    guard let title = isChanged else { return }
                    
                    switch indexPath.section {
                    case 0:
                        self.sectionOne[indexPath.row].title = title
                    default:
                        self.sectionTwo[indexPath.row].title = title
                    }
                }
                return checkIfNil(cell, indexPath: indexPath)
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: OrdinaryTableViewCell.reuseIdentifier, for: indexPath) as? OrdinaryTableViewCell
                cell?.dateLabel.text = date
                cell?.descriptionLabel.text = sectionOne[indexPath.row].description
                cell?.titleLabel.text = sectionOne[indexPath.row].title
                cell?.textChanged = {[weak self] (isChanged) in
                    guard let self = self else { return }
                    guard let title = isChanged else { return }
                    
                    switch indexPath.section {
                    case 0:
                        self.sectionOne[indexPath.row].title = title
                    default:
                        self.sectionTwo[indexPath.row].title = title
                    }
                }
                return checkIfNil(cell, indexPath: indexPath)
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdinaryTableViewCell.reuseIdentifier, for: indexPath) as? OrdinaryTableViewCell
            cell?.dateLabel.text = date
            cell?.descriptionLabel.text = sectionTwo[indexPath.row].description
            cell?.titleLabel.text = sectionTwo[indexPath.row].title
            cell?.textChanged = {[weak self] (isChanged) in
                guard let self = self else { return }
                guard let title = isChanged else { return }
                
                switch indexPath.section {
                case 0:
                    self.sectionOne[indexPath.row].title = title
                default:
                    self.sectionTwo[indexPath.row].title = title
                }
            }
            return checkIfNil(cell, indexPath: indexPath)
        }
    }
    
    // set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //headers for sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsNames[section]
    }
    
    //moving cell between sections
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let tempNote: Note = sectionOne[indexPath.row]
            sectionOne.remove(at: indexPath.row)
            sectionTwo.insert(tempNote, at: 0)
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 1))
        default:
            let tempNote: Note = sectionOne[indexPath.row]
            sectionTwo.remove(at: indexPath.row)
            sectionOne.insert(tempNote, at: 0)
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        }
        tableView.reloadData()
    }
}

