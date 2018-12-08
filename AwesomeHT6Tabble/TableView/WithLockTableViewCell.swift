//
//  WithLockTableViewCell.swift
//  AwesomeHT6Tabble
//
//  Created by Мостовий Ігор on 07.12.18.
//  Copyright © 2018 Мостовий Ігор. All rights reserved.
//

import UIKit

class WithLockTableViewCell: UITableViewCell {
    
    
    @IBOutlet  weak var titleLabel: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //handling of changing text
    var textChanged: ((String?) -> ())?
    
    @IBAction func titleChanged(_ sender: UITextField) {
        textChanged? (titleLabel.text)
    }
    
    static let reuseIdentifier: String = "WithLockTabbleViewCell"
    
}
