//
//  OrdinaryTableViewCell.swift
//  AwesomeHT6Tabble
//
//  Created by Мостовий Ігор on 07.12.18.
//  Copyright © 2018 Мостовий Ігор. All rights reserved.
//

import UIKit

class OrdinaryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    static let reuseIdentifier: String = "OrdinaryTableViewCell"
}
