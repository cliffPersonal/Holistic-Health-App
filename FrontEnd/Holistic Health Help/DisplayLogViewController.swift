//
//  DisplayLogViewController.swift
//  Holistic Health Help
//
//  Created by Clifford Lin on 4/25/22.
//

import Foundation
import UIKit

class DisplayLogViewController: UIViewController{
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var supplementTable: UITableView!
    @IBOutlet weak var symptomTable: UITableView!
    
    var dlog = DailyLog()
    var supplementsData = [String]()
    var symptomsData = [String]()
    var severityData = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        supplementTable.delegate = self
        supplementTable.dataSource = self
        symptomTable.delegate = self
        symptomTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var dlog = DailyLog()
        print("Selected Date:")
        print(Singleton.user.SELECTEDDATE)
        for i in 0 ..< Singleton.user.LOGS.count{
            print(Singleton.user.LOGS[i].DATE)
            if(Singleton.user.LOGS[i].DATE.contains(Singleton.user.SELECTEDDATE)){
                dlog = Singleton.user.LOGS[i]
            }
        }
        
        dateLabel.text = "Log on " + dlog.DATE
        supplementsData = dlog.SUPPLEMENTS
        supplementTable.reloadData()
        symptomsData = dlog.SYMPTOMS
        severityData = dlog.SEVERITIES
        symptomTable.reloadData()
    }
}

extension DisplayLogViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        if(tableView == self.supplementTable){
            count = supplementsData.count
        }
        if(tableView == self.symptomTable){
            count = symptomsData.count
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if(tableView == self.supplementTable){
            cell = tableView.dequeueReusableCell(withIdentifier: "SupCell", for: indexPath)
            cell!.textLabel?.text = supplementsData[indexPath.row]
        }
        if(tableView == self.symptomTable){
            cell = tableView.dequeueReusableCell(withIdentifier: "SymCell", for: indexPath)
            cell!.textLabel?.text = "Severity: " + String(severityData[indexPath.row]) + "   Symptom: " + symptomsData[indexPath.row]
        }
        return cell!
    }
}
