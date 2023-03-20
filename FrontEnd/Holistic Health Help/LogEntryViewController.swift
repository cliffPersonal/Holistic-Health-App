//
//  LogEntryViewController.swift
//  Holistic Health Help
//
//  Created by Clifford Lin on 4/22/22.
//

import Foundation
import UIKit

class LogEntryViewController: UIViewController{
    
    @IBOutlet weak var addSupplementButton: UIButton!
    @IBOutlet weak var addSymptomButton: UIButton!
    @IBOutlet weak var supplementTable: UITableView!
    @IBOutlet weak var symptomTable: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    let transparentView = UIView()
    let tableViewSupp = UITableView()
    let tableViewSymp = UITableView()
    
    var selectedButton = UIButton()
    
    var dataSource = [String]()
    var supplementsData = [String]()
    var symptomsData = [String]()
    
    var allSupplements = [String]()
    var allSymptoms = [String]()
    
    var date = ""
    var d = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        supplementTable.delegate = self
        supplementTable.dataSource = self
        symptomTable.delegate = self
        symptomTable.dataSource = self
        
        tableViewSupp.delegate = self
        tableViewSupp.dataSource = self
        tableViewSupp.register(CellClass.self, forCellReuseIdentifier: "CellSupp")
        tableViewSymp.delegate = self
        tableViewSymp.dataSource = self
        tableViewSymp.register(CellClass.self, forCellReuseIdentifier: "CellSymp")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateChange = dateFormatter.string(from: datePicker.date)
        //print(dateChange)
        
        let start = dateChange.index(dateChange.startIndex, offsetBy: 8)
        let end = dateChange.index(dateChange.endIndex, offsetBy: 0)
        let range = start ..< end
        let daySubstring = String(dateChange[range])
        
        let start2 = dateChange.index(dateChange.startIndex, offsetBy: 5)
        let end2 = dateChange.index(dateChange.endIndex, offsetBy: -3)
        let range2 = start2 ..< end2
        let monthSubstring = String(dateChange[range2])
        var monthNum = ""
        if(monthSubstring == "01"){
            monthNum = "Jan"
        }
        else if(monthSubstring == "02"){
            monthNum = "Feb"
        }
        else if(monthSubstring == "03"){
            monthNum = "Mar"
        }
        else if(monthSubstring == "04"){
            monthNum = "Apr"
        }
        else if(monthSubstring == "05"){
            monthNum = "May"
        }
        else if(monthSubstring == "06"){
            monthNum = "Jun"
        }
        else if(monthSubstring == "07"){
            monthNum = "Jul"
        }
        else if(monthSubstring == "08"){
            monthNum = "Aug"
        }
        else if(monthSubstring == "09"){
            monthNum = "Sep"
        }
        else if(monthSubstring == "10"){
            monthNum = "Oct"
        }
        else if(monthSubstring == "11"){
            monthNum = "Nov"
        }
        else if(monthSubstring == "12"){
            monthNum = "Dec"
        }
        
        let start3 = dateChange.index(dateChange.startIndex, offsetBy: 0)
        let end3 = dateChange.index(dateChange.startIndex, offsetBy: 4)
        let range3 = start3 ..< end3
        let yearSubstring = String(dateChange[range3])
        
        date = monthNum + " " + daySubstring + ", " + yearSubstring
        //print("Changed")
        //print(date)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateStyle = DateFormatter.Style.medium
        d = dateFormatter2.string(from: datePicker.date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getSupplementsRequest()
        print(Singleton.user.CONDITIONS)
        if(!Singleton.user.CONDITIONS.isEmpty){
            print("here")
            self.getSymptomsRequest()
        }
        self.getAllLogs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.getSupplementsRequest()
        //self.getSymptomsRequest()
        //self.getAllLogs()
    }
    
    @objc func removeTransparentViewSupp(){
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.transparentView.alpha = 0
            self.tableViewSupp.frame = CGRect(x: self.view.frame.maxX/2 - 150, y: 200, width: 0, height: 0)
        }, completion: nil)
    }
    
    @objc func removeTransparentViewSymp(){
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.transparentView.alpha = 0
            self.tableViewSymp.frame = CGRect(x: self.view.frame.maxX/2 - 150, y: 200, width: 0, height: 0)
        }, completion: nil)
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateChange = dateFormatter.string(from: datePicker.date)
        //print(dateChange)
        
        let start = dateChange.index(dateChange.startIndex, offsetBy: 8)
        let end = dateChange.index(dateChange.endIndex, offsetBy: 0)
        let range = start ..< end
        let daySubstring = String(dateChange[range])
        
        let start2 = dateChange.index(dateChange.startIndex, offsetBy: 5)
        let end2 = dateChange.index(dateChange.endIndex, offsetBy: -3)
        let range2 = start2 ..< end2
        let monthSubstring = String(dateChange[range2])
        var monthNum = ""
        if(monthSubstring == "01"){
            monthNum = "Jan"
        }
        else if(monthSubstring == "02"){
            monthNum = "Feb"
        }
        else if(monthSubstring == "03"){
            monthNum = "Mar"
        }
        else if(monthSubstring == "04"){
            monthNum = "Apr"
        }
        else if(monthSubstring == "05"){
            monthNum = "May"
        }
        else if(monthSubstring == "06"){
            monthNum = "Jun"
        }
        else if(monthSubstring == "07"){
            monthNum = "Jul"
        }
        else if(monthSubstring == "08"){
            monthNum = "Aug"
        }
        else if(monthSubstring == "09"){
            monthNum = "Sep"
        }
        else if(monthSubstring == "10"){
            monthNum = "Oct"
        }
        else if(monthSubstring == "11"){
            monthNum = "Nov"
        }
        else if(monthSubstring == "12"){
            monthNum = "Dec"
        }
        
        let start3 = dateChange.index(dateChange.startIndex, offsetBy: 0)
        let end3 = dateChange.index(dateChange.startIndex, offsetBy: 4)
        let range3 = start3 ..< end3
        let yearSubstring = String(dateChange[range3])
        
        date = monthNum + " " + daySubstring + ", " + yearSubstring
        //print("Changed")
        //print(date)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateStyle = DateFormatter.Style.medium
        d = dateFormatter2.string(from: datePicker.date)
        //date = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        var dateAlreadyExists = false
        var ds = [String]()
        print(Singleton.user.LOGS)
        for dt in Singleton.user.LOGS{
            ds.append(dt.DATE)
        }
        
        for dt in ds{
            if(dt.contains(date)){
                dateAlreadyExists = true
            }
        }
        
        if(!dateAlreadyExists){
            var thisLog = DailyLog()
            thisLog.DATE = date
            thisLog.SUPPLEMENTS = supplementsData
            thisLog.SYMPTOMS = symptomsData
            for c in symptomTable.visibleCells as! Array<SymptomCell>{
                thisLog.SEVERITIES.append(c.severityValue)
            }
            Singleton.user.LOGS.append(thisLog)
            for supplement in thisLog.SUPPLEMENTS {
               self.supplementLogRequest(user_id: Singleton.user.USER_ID, supp_name: supplement, date: d)
            }
            
            var i = 0
            for symptom in thisLog.SYMPTOMS {
                self.symptomLogRequest(user_id: Singleton.user.USER_ID, symp_name: symptom, severity: thisLog.SEVERITIES[i], date: d)
                i += 1
            }
            
            datePicker.date = Date()
            supplementsData = []
            supplementTable.reloadData()
            symptomsData = []
            symptomTable.reloadData()
            let alert = UIAlertController(title: "Save Successful!", message: "Click on Calendar to see you logs", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Save Unsuccessful!", message: "Date selected has already has a log", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func addSupplement(_ sender: Any) {
        
        dataSource = self.allSupplements
        selectedButton = addSupplementButton
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableViewSupp.frame = CGRect(x: self.view.frame.maxX/2 - 150, y: 50, width: 300, height: CGFloat(150))
        self.view.addSubview(tableViewSupp)
        tableViewSupp.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        //tableViewC.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentViewSupp))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableViewSupp.frame = CGRect(x: self.view.frame.maxX/2 - 150, y: 200, width: 300, height: CGFloat(150))
        }, completion: nil)
    }
    
    @IBAction func addSymptom(_ sender: Any) {
        //dataSource = ["Symp1", "Symp2", "Symp3"]
        dataSource = self.allSymptoms
        selectedButton = addSupplementButton
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableViewSymp.frame = CGRect(x: self.view.frame.maxX/2 - 150, y: 50, width: 300, height: CGFloat(150))
        self.view.addSubview(tableViewSymp)
        tableViewSymp.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        //tableViewC.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentViewSymp))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableViewSymp.frame = CGRect(x: self.view.frame.maxX/2 - 150, y: 200, width: 300, height: CGFloat(150))
        }, completion: nil)
    }
    
}

extension LogEntryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        
        if(tableView == self.supplementTable){
            count = supplementsData.count
        }
        if(tableView == self.symptomTable){
            count = symptomsData.count
        }
        if(tableView == self.tableViewSupp || tableView == self.tableViewSymp){
            count = dataSource.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if(tableView == self.tableViewSupp){
            cell = tableView.dequeueReusableCell(withIdentifier: "CellSupp", for: indexPath)
            cell!.textLabel?.text = dataSource[indexPath.row]
        }
        if(tableView == self.tableViewSymp){
            cell = tableView.dequeueReusableCell(withIdentifier: "CellSymp", for: indexPath)
            cell!.textLabel?.text = dataSource[indexPath.row]
        }
        if(tableView == self.supplementTable){
            cell = tableView.dequeueReusableCell(withIdentifier: "SuCell", for: indexPath)
            cell!.textLabel?.text = supplementsData[indexPath.row]
        }
        if(tableView == self.symptomTable){
            let thisCell = tableView.dequeueReusableCell(withIdentifier: "SyCell", for: indexPath) as! SymptomCell
            thisCell.symptomLabel.text = symptomsData[indexPath.row]
            //cell!.textLabel?.text = symptomsData[indexPath.row]
            return thisCell
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.tableViewSupp){
            supplementsData.append(dataSource[indexPath.row])
            self.supplementTable.reloadData()
            removeTransparentViewSupp()
            self.tableViewSupp.deselectRow(at: indexPath, animated: true)
        }
        if(tableView == self.tableViewSymp){
            symptomsData.append(dataSource[indexPath.row])
            self.symptomTable.reloadData()
            removeTransparentViewSymp()
            self.tableViewSymp.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            if(tableView == self.supplementTable){
                self.supplementsData.remove(at: indexPath.row)
                self.supplementTable.deleteRows(at: [indexPath], with: .automatic)
                supplementTable.reloadData()
            }
            if(tableView == self.symptomTable){
                self.symptomsData.remove(at: indexPath.row)
                self.symptomTable.deleteRows(at: [indexPath], with: .automatic)
                symptomTable.reloadData()
            }
        }
        
    }
    
    
    
    
    
    
    
    /*
     
     *****
     HTTPRequest
     *****
     
     */
    func backendDateFormat(date: String) -> String{
        print("Day")
        print(date)
        let start = date.index(date.startIndex, offsetBy: 4)
        let end = date.index(date.endIndex, offsetBy: -6)
        let range = start ..< end
        let daySubstring = String(date[range])
        
        let start2 = date.index(date.startIndex, offsetBy: 0)
        let end2 = date.index(date.startIndex, offsetBy: 3)
        let range2 = start2 ..< end2
        let monthSubstring = String(date[range2])
        var monthNum = ""
        if(monthSubstring == "Jan"){
            monthNum = "01"
        }
        else if(monthSubstring == "Feb"){
            monthNum = "02"
        }
        else if(monthSubstring == "Mar"){
            monthNum = "03"
        }
        else if(monthSubstring == "Apr"){
            monthNum = "04"
        }
        else if(monthSubstring == "May"){
            monthNum = "05"
        }
        else if(monthSubstring == "Jun"){
            monthNum = "06"
        }
        else if(monthSubstring == "Jul"){
            monthNum = "07"
        }
        else if(monthSubstring == "Aug"){
            monthNum = "08"
        }
        else if(monthSubstring == "Sep"){
            monthNum = "09"
        }
        else if(monthSubstring == "Oct"){
            monthNum = "10"
        }
        else if(monthSubstring == "Nov"){
            monthNum = "11"
        }
        else if(monthSubstring == "Dec"){
            monthNum = "12"
        }
        
        let start3 = date.index(date.endIndex, offsetBy: -4)
        let end3 = date.index(date.endIndex, offsetBy: 0)
        let range3 = start3 ..< end3
        let yearSubstring = String(date[range3])
        
        let dateStr = yearSubstring + "-" + monthNum + "-" + daySubstring + " 00:00:00"
        return dateStr
    }
    
    
    func supplementLogRequest(user_id: Int, supp_name: String, date: String) {
        let dateStr = backendDateFormat(date: date)
        
        let json: [String: Any] = ["USER_ID": user_id, "SUPPLEMENT": supp_name, "DATE": dateStr]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "http://localhost:8080/addSupplementLog")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
           // let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])

            // if let responseJSON = responseJSON as? [String: Any] { }
            
        }
        task.resume()
    } // supplement log request
    
    func symptomLogRequest(user_id: Int, symp_name: String, severity: Int, date: String) {
        let dateStr = backendDateFormat(date: date)
        //print(dateStr)
        
        let json: [String: Any] = ["USER_ID": user_id, "SYMPTOM": symp_name, "SEVERITY": severity, "DATE": dateStr]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "http://localhost:8080/addSymptomLog")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])

  //          if let responseJSON = responseJSON as? [String: Any] { }
            
        }
        task.resume()
    } // symptom log request
    
    
    func getAllLogs() {
    
        let json: [String: Any] = ["user_id": Singleton.user.USER_ID]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "http://localhost:8080/USERS/returnLogs")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])

            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                
                /*
                 {"DayLogs0":[{"SymptomInfo":{"SYMPTOM_ID":1,"SYMPTOM":"Vomiting","CONDITION_ID":0},"SymptomLog":{"SYMPTOM_LOG_ID":15,"TIMESTAMP":{"nanos":190000000},"USER_ID":1,"SYMPTOM_ID":1,"SEVERITY":4,"CONDITION_ID":1}}],
                 "DayLogs1":
                     [{"SymptomInfo":{"SYMPTOM_ID":0,"SYMPTOM":"Heart Palpitations","CONDITION_ID":0},"SymptomLog":{"SYMPTOM_LOG_ID":5,"TIMESTAMP":{"nanos":31875000},"USER_ID":1,"SYMPTOM_ID":0,"SEVERITY":3,"CONDITION_ID":0}},
                     {"SymptomInfo":{"SYMPTOM_ID":1,"SYMPTOM":"Vomiting","CONDITION_ID":0},"Symptom":{"SYMPTOM_LOG_ID":0,"TIMESTAMP":{"nanos":24957000},"USER_ID":1,"SYMPTOM_ID":1,"SEVERITY":7,"CONDITION_ID":0}},
                     {"SymptomInfo":{"SYMPTOM_ID":1,"SYMPTOM":"Vomiting","CONDITION_ID":0},"Symptom":{"SYMPTOM_LOG_ID":2,"TIMESTAMP":{"nanos":960233000},"USER_ID":1,"SYMPTOM_ID":1,"SEVERITY":6,"CONDITION_ID":0}},
                     {"Supplement":{"SUPPLEMENT_ID":0,"TIMESTAMP":{"nanos":10000000},"USER_ID":1,"SUPPLEMENT_LOG_ID":5,"DOSAGE_UNIT":"mg","DOSAGE":150},"SupplementInfo":{"SUPPLEMENT_ID":0,"DESCRIPTION":"Vitamin D","SYMPTOM_ID":0}},
                     {"Supplement":{"SUPPLEMENT_ID":0,"TIMESTAMP":{"nanos":189270000},"USER_ID":1,"SUPPLEMENT_LOG_ID":1,"DOSAGE_UNIT":"mg","DOSAGE":150},"SupplementInfo":{"SUPPLEMENT_ID":0,"DESCRIPTION":"Vitamin D","SYMPTOM_ID":0}}]}
                 */
                
                for (key, value) in responseJSON {
                    if key == "entity" {
                        
                        var v = String(describing: value)
                        var DayLogs = v.components(separatedBy:"DayLogs")
                        DayLogs.remove(at: 0)
                        Singleton.user.LOGS = []
                        for log in DayLogs {
                            
                            var thisLog = DailyLog()
                            
                            let cutIndex = log.firstIndex(of: "[")!
                            var l = String(log[cutIndex...])
                            /*
                             l =
                             [{"SymptomInfo":{"SYMPTOM_ID":0,"SYMPTOM":"Anxiety","CONDITION_ID":0},
                                "SymptomLog":{"SYMPTOM_LOG_ID":0,"TIMESTAMP":{"nanos":818000000},"USER_ID":0,"SYMPTOM_ID":0,"SEVERITY":7,"CONDITION_ID":0},"Date":"2022-05-02"},
                             {"SymptomInfo":{"SYMPTOM_ID":0,"SYMPTOM":"Anxiety","CONDITION_ID":0},
                                "SymptomLogs":{"SYMPTOM_LOG_ID":1,"TIMESTAMP":{"nanos":762000000},"USER_ID":0,"SYMPTOM_ID":0,"SEVERITY":4,"CONDITION_ID":0}},
                             {"SupplementLogs":{"SUPPLEMENT_ID":0,"TIMESTAMP":{"nanos":954000000},"USER_ID":0,"SUPPLEMENT_LOG_ID":0,"DOSAGE_UNIT":"eeeee","DOSAGE":0},
                                "SupplementInfo":{"SUPPLEMENT_ID":0,"DESCRIPTION":"Vitamin D","SYMPTOM_ID":0}}]}
                             */
                           // print("NEW")
                          //  print(l)
                            let num_supplements = l.components(separatedBy: "\"SupplementInfo\"").count - 1
                            
                            // if there are supplements
                            if (num_supplements > 0) == true {
                                let symp_supp_list = l.components(separatedBy: "\"SupplementLogs\"")
                                //print("symp_supp_list:")
                                //print(symp_supp_list)
                                let symptoms = symp_supp_list[0]
                                //print("symptoms:")
                                //print(symptoms)
                                var supp_list = [String]()
                                for i in 1..<(num_supplements+1) {
                                    supp_list.append(symp_supp_list[i])
                                }
                                var symp_list = symptoms.components(separatedBy: "SymptomInfo")
                                
                                var date = symp_list[0]
                                var whatmatters = date.components(separatedBy: ":")
                                var cs = CharacterSet.init(charactersIn: "\"},{\"")
                                date = whatmatters[1].trimmingCharacters(in: cs)
                                cs = CharacterSet.init(charactersIn: "\"")
                                date = date.trimmingCharacters(in: cs)
                                
                                let start = date.index(date.startIndex, offsetBy: 0)
                                let end = date.index(date.endIndex, offsetBy: -6)
                                let range = start ..< end
                                let yearsub = date[range]
                                //print(yearsub)
                                let start2 = date.index(date.startIndex, offsetBy: 5)
                                let end2 = date.index(date.endIndex, offsetBy: -3)
                                let range2 = start2 ..< end2
                                let monthsub = date[range2]
                                var mChar = ""
                                if(monthsub == "01"){
                                    mChar = "Jan"
                                }
                                else if(monthsub == "02"){
                                    mChar = "Feb"
                                }
                                else if(monthsub == "03"){
                                    mChar = "Mar"
                                }
                                else if(monthsub == "04"){
                                    mChar = "Apr"
                                }
                                else if(monthsub == "05"){
                                    mChar = "May"
                                }
                                else if(monthsub == "06"){
                                    mChar = "Jun"
                                }
                                else if(monthsub == "07"){
                                    mChar = "Jul"
                                }
                                else if(monthsub == "08"){
                                    mChar = "Aug"
                                }
                                else if(monthsub == "09"){
                                    mChar = "Sep"
                                }
                                else if(monthsub == "10"){
                                    mChar = "Oct"
                                }
                                else if(monthsub == "11"){
                                    mChar = "Nov"
                                }
                                else if(monthsub == "12"){
                                    mChar = "Dec"
                                }
                                //print(monthsub)
                                //print(mChar)
                                let start3 = date.index(date.startIndex, offsetBy: 8)
                                let end3 = date.index(date.endIndex, offsetBy: 0)
                                let range3 = start3 ..< end3
                                let daysub = date[range3]
                                //print(daysub)
                                let dStrFinal = mChar + " " + daysub + ", " + yearsub
                                //print(dStrFinal)

                                //print("date?")
                                //print(dStrFinal)
                                // date variable FORMAT DATE 2022-04-28 --> 04/28/22
                                thisLog.DATE = dStrFinal
                                
                                symp_list.remove(at: 0)
                                
                                for symp in symp_list {
                                    
                                    let s = symp.components(separatedBy: ",")
                                    var whatmatters = s[1].components(separatedBy: ":")
                                    let cs = CharacterSet.init(charactersIn: "\"")
                                    let sympName = whatmatters[1].trimmingCharacters(in: cs)
                                    print(sympName)
                                    thisLog.SYMPTOMS.append(sympName)
                                    
                                    whatmatters = s[7].components(separatedBy: ":")
                                    thisLog.SEVERITIES.append(Int(whatmatters[1])!)
                                    
                                }
                                
                                //print(thisLog.SYMPTOMS)
                                //print(thisLog.SEVERITIES)

                                
                                for supp in supp_list {

                                    var s = supp.components(separatedBy: "SupplementInfo")
                                    s.remove(at: 0)
                                    for thisSupp in s {
                                        var suppNameList = thisSupp.components(separatedBy: ":")
                                        suppNameList = suppNameList[3].components(separatedBy: ",")
                                        let cs = CharacterSet.init(charactersIn: "\"")
                                        let suppName = suppNameList[0].trimmingCharacters(in: cs)
                                        print(suppName)
                                        thisLog.SUPPLEMENTS.append(suppName)
                                    }
                                    
                                    
                                    
                                }
                                //print("Here")
                                //print(thisLog.SUPPLEMENTS)
                                Singleton.user.LOGS.append(thisLog)
                            }
                            print("LOGS:")
                            print(Singleton.user.LOGS)
                        
                        }
                        
                        
                        
                      /*
                       
                       Singleton.user.LOGS.append(dailylog)
                       
                       */
                
                    }
                            
                }
            }
            
        }
        task.resume()
    } // getAllLogs
    
    func getSupplementsRequest() {
        
        let url = URL(string: "http://localhost:8080/SUPPLEMENTS/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            var v = String(describing: responseJSON)
            let cutIndex = v.firstIndex(of: ">")!
            v = String(v[cutIndex...])
            let cs = CharacterSet.init(charactersIn: ">( )\n)")
            v = v.trimmingCharacters(in: cs)
            //print(v)
            
            let supplements = v.components(separatedBy: ",")
            self.allSupplements = []
            Singleton.user.USER_SUPPLEMENTS = []
            for supp in supplements{
                var s = supp.trimmingCharacters(in: .whitespacesAndNewlines)
                let partsA = s.components(separatedBy: ";")
                let partsB = partsA[0].components(separatedBy: "=")
                var thisSupp = partsB[1]
                let start = thisSupp.index(thisSupp.startIndex, offsetBy: 2)
                let end = thisSupp.index(thisSupp.endIndex, offsetBy: -1)
                let range = start ..< end
                thisSupp = String(thisSupp[range])
                
                self.allSupplements.append(thisSupp)
                Singleton.user.USER_SUPPLEMENTS.append(thisSupp)
            }
            
        }
        task.resume()

    } //getSupplementsRequest
    
    func getSymptomsRequest() {
        
        for userCondition in Singleton.user.CONDITIONS {
            
            let json: [String: Any] = ["condition_name": userCondition]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)

            let url = URL(string: "http://localhost:8080/getSymptoms")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])

                if let responseJSON = responseJSON as? [String: Any] {
                    
                    for (key, value) in responseJSON {
                        if key == "entity" {
                            var v = String(describing: value)
                            // {"symptoms":[{"SYMPTOM_ID":0,"SYMPTOM":"Heart Palpitations","CONDITION_ID":0},{"SYMPTOM_ID":1,"SYMPTOM":"Vomiting","CONDITION_ID":0},{"SYMPTOM_ID":2,"SYMPTOM":"Purple Discoloration of Hands and Feet","CONDITION_ID":0}]}
                            
                            var cs = CharacterSet.init(charactersIn: "{ }")
                            v = v.trimmingCharacters(in: cs)
                            let sParts = v.components(separatedBy: ":[")
                            // sParts[0] = "symptoms"
                            // sParts[1] = [{"SYMPTOM_ID":0,"SYMPTOM":"Heart Palpitations","CONDITION_ID":0},{"SYMPTOM_ID":1,"SYMPTOM":"Vomiting","CONDITION_ID":0},{"SYMPTOM_ID":2,"SYMPTOM":"Purple Discoloration of Hands and Feet","CONDITION_ID":0}]
                            var sList = sParts[1]
                            cs = CharacterSet.init(charactersIn: "[ ]")
                            sList = sList.trimmingCharacters(in: cs)
                            let symptomsList = sList.components(separatedBy: "},{")
                            
                            self.allSymptoms = []
                            Singleton.user.USER_SYMPTOMS = []
                            
                            for symptom in symptomsList {
                                // symptom = {"SYMPTOM_ID":0,"SYMPTOM":"Heart Palpitations","CONDITION_ID":0
                                cs = CharacterSet.init(charactersIn: "{")
                                let userSymptom = symptom.trimmingCharacters(in: cs)
                                // userSymptom = "SYMPTOM_ID":0,"SYMPTOM":"Heart Palpitations","CONDITION_ID":0
                                var sympParts = userSymptom.components(separatedBy: ",")
                                let sympPartsStr = sympParts[1]
                                sympParts = sympPartsStr.components(separatedBy: ":")
                                cs = CharacterSet.init(charactersIn: "\"")
                                let sympName = sympParts[1].trimmingCharacters(in: cs)
                                self.allSymptoms.append(sympName)
                                Singleton.user.USER_SYMPTOMS.append(sympName)
                            }
                        
                        }
                                
                    }
                    
                }
                
            }
            task.resume()
            
        }
       

    } //getSupplementsRequest
    
    
    
} // LogEntryViewController

