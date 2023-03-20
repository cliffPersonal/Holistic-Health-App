//
//  SymptomCell.swift
//  Holistic Health Help
//
//  Created by Clifford Lin on 4/27/22.
//

import Foundation
import UIKit

class SymptomCell: UITableViewCell{
    @IBOutlet weak var symptomLabel: UILabel!
    @IBOutlet weak var severityStepper: UIStepper!
    @IBOutlet weak var severityLabel: UILabel!
    var severityValue = 1
    
    @IBAction func stepperChanged(_ sender: Any) {
        severityValue = (Int)( severityStepper.value)
        severityLabel.text = String(severityValue)
    }
    
}
