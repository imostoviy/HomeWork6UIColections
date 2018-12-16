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
        var date: String
        var complited: Bool
        
        init(_ title: String, _ description: String, _ date: String, _ complited: Bool) {
            self.title = title
            self.description = description
            self.date = date
            self.complited = complited
        }
    }
    private var standartDate: String = ""
    private var sectionOne: [Note] = []
    private var sectionTwo: [Note] = []
    private let sectionsNames: [String] = ["Count", "Complited"]
    private let unlock: String = "відімкнено"
    private var lastModified: String = ""
    
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
        let ordinaryCell = UINib(nibName: "OrdinaryTableViewCell", bundle: nil)
        let withLockCell = UINib(nibName: "WithLockTableViewCell", bundle: nil)
        tableView.register(ordinaryCell, forCellReuseIdentifier: OrdinaryTableViewCell.reuseIdentifier)
        tableView.register(withLockCell, forCellReuseIdentifier: WithLockTableViewCell.reuseIdentifier)
        
        let tmpForDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        self.standartDate = formatter.string(from: tmpForDate)
        self.sectionOne = [Note("Dictionary", "intent - намір", standartDate, false),
                            Note("582 Заправка", "Some text", standartDate, false),
                            Note("Some title three", "Some text", standartDate, false),
                            Note("Some title four", "Some text", standartDate, false),
                            Note("Some title five", "Some text", standartDate, false),
                            Note("some title six", "Some text", standartDate, false),
                            Note("Some title seven", "Some text", standartDate, false),
                                  ]
        self.sectionTwo = [Note("Section two", "test", standartDate, true)]
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
                cell?.dateLabel.text = sectionOne[indexPath.row].date //remowe this!
                cell?.descriptionLabel.text = unlock
                cell?.titleLabel.text = sectionOne[indexPath.row].title
                return checkIfNil(cell, indexPath: indexPath)
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: OrdinaryTableViewCell.reuseIdentifier, for: indexPath) as? OrdinaryTableViewCell
                cell?.dateLabel.text = sectionOne[indexPath.row].date
                cell?.descriptionLabel.text = sectionOne[indexPath.row].description
                cell?.titleLabel.text = sectionOne[indexPath.row].title
                return checkIfNil(cell, indexPath: indexPath)
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdinaryTableViewCell.reuseIdentifier, for: indexPath) as? OrdinaryTableViewCell
            cell?.dateLabel.text = sectionTwo[indexPath.row].date
            cell?.descriptionLabel.text = sectionTwo[indexPath.row].description
            cell?.titleLabel.text = sectionTwo[indexPath.row].title
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
    
    //MARK: - editing
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "TableView", bundle: nil)
        let editController = storyboard.instantiateViewController(withIdentifier: "EditScreen") as! EditScreen
        editController.title = "Edit Note"
        switch indexPath.section {
        case 0:
            editController.note = sectionOne[indexPath.row]
        default:
            editController.note = sectionTwo[indexPath.row]
        }
        editController.lastModified = lastModified
        navigationController?.pushViewController(editController, animated: true)
        
        //pushing note into rignt section
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        editController.editedNote = { (note) in
            guard let noteToPush = note else { return }
            self.lastModified = noteToPush.title
            switch indexPath.section{
            case 0:
                if noteToPush.complited {
                    self.sectionOne.remove(at: indexPath.row)
                    self.sectionTwo.append(noteToPush)
                    self.sectionTwo.sort(by: {formatter.date(from: $0.date)! < formatter.date(from: $1.date)!})
                } else {
                    self.sectionOne[indexPath.row] = noteToPush
                    self.sectionOne.sort(by: {formatter.date(from: $0.date)! < formatter.date(from: $1.date)!})
                }
            default:
                if !noteToPush.complited {
                    self.sectionTwo.remove(at: indexPath.row)
                    self.sectionOne.append(noteToPush)
                    self.sectionOne.sort(by: {formatter.date(from: $0.date)! < formatter.date(from: $1.date)!})
                } else {
                    self.sectionTwo[indexPath.row] = noteToPush
                    self.sectionTwo.sort(by: {formatter.date(from: $0.date)! < formatter.date(from: $1.date)!})
                }
            }
            self.tableView.reloadData()
        }
    }
    
    //MARK: - calling addController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNote" {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let addController = segue.destination as! AddScreen
            addController.title = "Add Note"
            addController.stadartDate = standartDate
            addController.newNote = { (note) in
                guard let neadToAddNote = note else { return }
                switch neadToAddNote.complited {
                case true:
                    self.sectionTwo.append(neadToAddNote)
                    self.sectionTwo.sort(by: {formatter.date(from: $0.date)! < formatter.date(from: $1.date)!})
                default:
                    self.sectionOne.append(neadToAddNote)
                    self.sectionOne.sort(by: {formatter.date(from: $0.date)! < formatter.date(from: $1.date)!})
                }
                self.tableView.reloadData()
            }
        }
    }
}

