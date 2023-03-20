//
//  ViewController.swift
//  Holistic Health Help
//
//  Created by Clifford Lin on 2/15/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var result: Bool = false
    var registerP: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func registerPressed(_ sender: UIButton) {
        print("rp")
        registerP = true
    }
    
    @IBAction func emailExit(_ sender: UITextField) {
        emailTextField.resignFirstResponder()
    }
    
    @IBAction func passwordExit(_ sender: UITextField) {
        passwordTextField.resignFirstResponder()
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        
      //jsonRequest(email: email, password: password)
    
    }

        
    func jsonRequest(email: String, password: String) {
        
        let json: [String: Any] = ["USER_ID": 0, "EMAIL": email, "PASSWORD": password, "FIRSTNAME": "", "LASTNAME": "", "BIRTHDATE": 0]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "http://localhost:8080/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let sem = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            
            defer { sem.signal() }
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])

            if let responseJSON = responseJSON as? [String: Any] {
                // print(responseJSON)
                
                for (key, value) in responseJSON {
                    if key == "entity" {
                        var v = String(describing: value)
                        if v.contains("Login failed.") {
                            result = true
                        } else {
                            
                            
                            // PARSE THE JSON TO USER STRUCT MANUALLY
                            var userParts = [String]()
                            var cs = CharacterSet.init(charactersIn: "{ }")
                            v = v.trimmingCharacters(in: cs)
                            let pairs = v.components(separatedBy: ",")
                            for pair in pairs {
                                let pairParts = pair.components(separatedBy: ":")
                                cs = CharacterSet.init(charactersIn: "\"")
                                let valueOnly = pairParts[1].trimmingCharacters(in: cs)
                                userParts.append(valueOnly)
                            }
                            let user_id = Int(userParts[2]) ?? 0

                            Singleton.user.LOGGEDIN = true
                            Singleton.user.PASSWORD = userParts[0]
                            Singleton.user.LASTNAME = userParts[1]
                            Singleton.user.USER_ID = user_id
                            Singleton.user.FIRSTNAME = userParts[3]
                            if userParts[4] == "{}" {
                                Singleton.user.BIRTHDATE = "2000-01-01"
                            } else {
                                Singleton.user.BIRTHDATE = userParts[4]
                            }
                            Singleton.user.EMAIL = userParts[5]

                            result = false
                                    
                        }
                    }
                            
                }
                
            }
            
        }
        task.resume()
        sem.wait()
        
    } // end jsonRequest func

    
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
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        let email:String = emailTextField.text!
        let password:String = passwordTextField.text!
        
        self.jsonRequest(email: email, password: password)
        if result == false  {
            self.userConditionsRequest()
        }
        
        if emailTextField.text?.isEmpty == true && passwordTextField.text?.isEmpty == true {
            performSegue(withIdentifier: "registerSegue", sender: self)
        }
        
        let badParams = result
        
        if badParams {
            
            let alertController = UIAlertController(title: "Login Error", message: "Invalid Email and/or Password", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okButton)
            self.present(alertController, animated: true, completion: nil                                   )
            return false
            
        } else {
            // print("performSegue")
            // print(user)
            // self.performSegue(withIdentifier: "homeSegue", sender: user)
            return true
        }
    } // end shouldPerformSegue func bracket
    
    /*
    func prepareForSegue(segue: UIStoryboardSegue, sender: [User]) {
        if segue.identifier == "homeSegue" {
            if let vc: HomeViewController = segue.destination as? HomeViewController {
                print("prepare")
                print(user)
                vc.catchUser = user
            }
        }
    }
     */


} // end ViewController class bracket
