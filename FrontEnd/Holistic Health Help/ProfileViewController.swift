//
//  ProfileViewController.swift
//  Holistic Health Help
//
//  Created by Clifford Lin on 4/25/22.
//

/*
 
 FRONT END TO-DO:
    - User Conditions are loaded into Singleton (Singleton.user.CONDITIONS), will not display on profile?
    - addContitions & deleteConditions : nothing on frontend perspective but backend won't work, so needs testing at least
 
 */

import Foundation
import UIKit

class CellClass: UITableViewCell{
    
}

class ProfileViewController: UIViewController{
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    
    @IBOutlet weak var AddConditionBtn: UIButton!
    @IBOutlet weak var ConditionTbl: UITableView!
    
    
    let transparentView = UIView()
    let tableViewCond = UITableView()
    
    var selectedButton = UIButton()
    
    var dataSource = [String]()
    var conditionsData = [String]()
    
    var allConditions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConditionTbl.delegate = self
        ConditionTbl.dataSource = self
        
        tableViewCond.delegate = self
        tableViewCond.dataSource = self
        tableViewCond.register(CellClass.self, forCellReuseIdentifier: "Condition")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        welcomeLabel.text = "Welcome, " + Singleton.user.FIRSTNAME + "!"
        firstnameLabel.text = "First name: " + Singleton.user.FIRSTNAME
        lastnameLabel.text = "Last name: " + Singleton.user.LASTNAME
        emailLabel.text = "Email: " + Singleton.user.EMAIL
        birthdateLabel.text = "Birthdate: " + Singleton.user.BIRTHDATE
        
        conditionsData = Singleton.user.CONDITIONS
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.conditionsRequest()
        self.userConditionsRequest()
        conditionsData = Singleton.user.CONDITIONS
        print(conditionsData)
        ConditionTbl.reloadData()
    }
    
    @objc func removeTransparentViewCond(){
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.transparentView.alpha = 0
            self.tableViewCond.frame = CGRect(x: self.view.frame.maxX/2 - 150, y: 200, width: 0, height: 0)
        }, completion: nil)
    }
    @IBAction func logout(_ sender: UIButton) {
        Singleton.user.destroy()
    }
    
    
    
    @IBAction func AddConditionPressed(_ sender: Any) {
        dataSource = self.allConditions
        //dataSource = ["POTS"]
        selectedButton = AddConditionBtn
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableViewCond.frame = CGRect(x: self.view.frame.maxX/2 - 150, y: 50, width: 300, height: CGFloat(150))
        self.view.addSubview(tableViewCond)
        tableViewCond.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        //tableViewC.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentViewCond))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableViewCond.frame = CGRect(x: self.view.frame.maxX/2 - 150, y: 200, width: 300, height: CGFloat(150))
        }, completion: nil)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        
        if(tableView == self.ConditionTbl){
            count = conditionsData.count
        }
        if(tableView == self.tableViewCond){
            count = dataSource.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if(tableView == self.tableViewCond){
            cell = tableView.dequeueReusableCell(withIdentifier: "Condition", for: indexPath)
            cell!.textLabel?.text = dataSource[indexPath.row]
        }
        if(tableView == self.ConditionTbl){
            cell = tableView.dequeueReusableCell(withIdentifier: "ConditionCell", for: indexPath)
            cell!.textLabel?.text = conditionsData[indexPath.row]
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.tableViewCond){
            conditionsData.append(dataSource[indexPath.row])
            if(conditionsData[0] == ""){
                conditionsData.remove(at: 0)
            }
            Singleton.user.CONDITIONS = conditionsData
            self.ConditionTbl.reloadData()
            removeTransparentViewCond()
            self.tableViewCond.deselectRow(at: indexPath, animated: true)
            
            // call to backend to addCondition
            self.addCondition(condition: dataSource[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            if(tableView == self.ConditionTbl){
                self.conditionsData.remove(at: indexPath.row)
                self.ConditionTbl.deleteRows(at: [indexPath], with: .automatic)
                ConditionTbl.reloadData()
                //print(Singleton.user.CONDITIONS)
                
                // call to frontend to deleteCondition
                self.deleteCondition(condition: Singleton.user.CONDITIONS[indexPath.row])
                Singleton.user.CONDITIONS.remove(at: indexPath.row)
            }
        }
    }
    
    
    
    
    /*
     
     *****
     HTTPRequest
     *****
     
     */
    
    func conditionsRequest() {

        let url = URL(string: "http://localhost:8080/allConditions")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            var v = String(describing: responseJSON)
            let cutIndex = v.firstIndex(of: ">")!
            v = String(v[cutIndex...])
            var cs = CharacterSet.init(charactersIn: ">( )\n)")
            v = v.trimmingCharacters(in: cs)
            
            let conditions = v.components(separatedBy: ",")
            
            self.allConditions = []
            for condition in conditions {
                // cs = CharacterSet.init(charactersIn: "{ }")
                //var c = condition.trimmingCharacters(in: cs)
                let cParts = condition.components(separatedBy: ";")
                let cNameParts = cParts[1].components(separatedBy: " = ")
                cs = CharacterSet.init(charactersIn: "\"")
                let cName = cNameParts[1].trimmingCharacters(in: cs)
                
                self.allConditions.append(cName)
                
            }
            
            
        }
        task.resume()
        
    } // end conditionsRequest
    
    
    func userConditionsRequest() {

        let json: [String: Any] = ["user_id": Singleton.user.USER_ID]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "http://localhost:8080/getConditions")!
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
                        // {"conditions":["Myalgic encephalomyelitis\/chronic fatigue syndrome (ME\/CFS)"]}
                        var cs = CharacterSet.init(charactersIn: "{ }")
                        v = v.trimmingCharacters(in: cs)
                        let cParts = v.components(separatedBy: ":")
                        // cParts[0] = "conditions"
                        // cParts[1] = ["Myalgic encephalomyelitis\/chronic fatigue syndrome (ME\/CFS)"]
                        var cList = cParts[1]
                        cs = CharacterSet.init(charactersIn: "[ ]")
                        cList = cList.trimmingCharacters(in: cs)
                        let conditionList = cList.components(separatedBy: ",")
                        
                        Singleton.user.CONDITIONS = []
                        for condition in conditionList {
                            cs = CharacterSet.init(charactersIn: "\" \"")
                            let userCondition = condition.trimmingCharacters(in: cs)
                            Singleton.user.CONDITIONS.append(userCondition)
                        }
                        
            
                    }
                }
                            
            }
            
        }
        task.resume()
        
    } // end conditionssRequest
    
    func addCondition(condition: String) {

        let json: [String: Any] = ["user": Singleton.user.USER_ID, "name": condition]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "http://localhost:8080/USERCONDITIONS/addCondition")!
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
            print(responseJSON)
        }
        task.resume()
        
    } // end addCondition
    
    
    func deleteCondition(condition: String) {
        print(condition)
        let json: [String: Any] = ["user_id": Singleton.user.USER_ID, "condition_name": condition]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "http://localhost:8080/USERCONDITIONS/deleteCondition")!
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
            print(responseJSON)
        }
        task.resume()
        
    } // end conditionssRequest
    
    
 
    
} //end ProfileViewController
