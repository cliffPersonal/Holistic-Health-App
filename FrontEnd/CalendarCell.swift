//
//  CalendarCell.swift
//  Holistic Health Help
//
//  Created by Clifford Lin on 4/15/22.
//

import UIKit

class CalendarCell: UICollectionViewCell{
    @IBOutlet weak var dayOfMonth: UIButton!
    var Date = ""
    
    
    @IBAction func datePressed(_ sender: Any) {
        Singleton.user.SELECTEDDATE = Date
        //print("Here:")
        //print(Singleton.user.SELECTEDDATE)
    }
}
