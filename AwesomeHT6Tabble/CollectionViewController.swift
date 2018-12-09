//
//  CollectionViewController.swift
//  AwesomeHT6Tabble
//
//  Created by Мостовий Ігор on 09.12.18.
//  Copyright © 2018 Мостовий Ігор. All rights reserved.
//

import UIKit


class CollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let awesomeCell = UINib(nibName: "AwesomeCollectionViewCell", bundle: nil)
        self.collectionView!.register(awesomeCell, forCellWithReuseIdentifier: AwesomeCollectionViewCell.reuseIdentity)
        //instaling custom set to elements in row
        let collectionViewWidth = collectionView?.frame.width
        let itemWidth = (collectionViewWidth! - sizes.leftAndRightPading)/sizes.elementsInPerRow
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth )
    }
    struct Month {
        let nameOfMonth: String
        let daysInMonth: [Int]
        init (_ name: String, _ numOfDays: Int) {
            nameOfMonth = name
            daysInMonth = Array<Int>(1...numOfDays)
        }
    }
    //using for made number of elements in row and to set paddings between elements
    struct sizes {
        static let leftAndRightPading: CGFloat = 2.0
        static let elementsInPerRow: CGFloat = 8.0
    }
    
    let months: [Month] = [Month("January", 31),
                           Month("February", 28),
                           Month("March", 31),
                           Month("April",30),
                           Month("May", 31),
                           Month("June", 30),
                           Month("July",31),
                           Month("August",31),
                           Month("September",30),
                           Month("October",31),
                           Month("November", 30),
                           Month("December",31)]
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return months.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months[section].daysInMonth.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AwesomeCollectionViewCell.reuseIdentity, for: indexPath)
        let checkingParsing: String? = String(months[indexPath.section].daysInMonth[indexPath.item])
        guard let date = checkingParsing else {
            (cell as? AwesomeCollectionViewCell)?.dayLabel.text = "Error in parsing"
        }
        (cell as? AwesomeCollectionViewCell)?.dayLabel.text = date
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderCollectionReusableView
        header.headerLabel.text = months[indexPath.section].nameOfMonth
        return header
    }
 
}
