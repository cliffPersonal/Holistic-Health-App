//
//  EditViewController.swift
//  Holistic Health Help
//
//  Created by Judy Song on 4/21/22.
//

import Foundation
import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var birthdatePicker: UIDatePicker!
    
    var date = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //conditionsTable.delegate = self
        //conditionsTable.dataSource = self
        
        // DEFAULT VALUES FOR THESE VARIABLES !!!!! needed
        
    } // end viewDidLoad()
    
    override func viewWillAppear(_ animated: Bool) {
        firstNameText.text = Singleton.user.FIRSTNAME
        lastNameText.text = Singleton.user.LASTNAME
        emailText.text = Singleton.user.EMAIL
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        birthdatePicker.date = dateformatter.date(from: Singleton.user.BIRTHDATE)!
        //date --> do
    }
    
    @IBAction func savePressed(_ sender: Any) {
    
        var fname:String = firstNameText.text!
        if firstNameText.text?.isEmpty == true {
            fname = Singleton.user.FIRSTNAME
        }
        var lname:String = lastNameText.text!
        if lastNameText.text?.isEmpty == true {
            lname = Singleton.user.LASTNAME
        }
        var email:String = emailText.text!
        if emailText.text?.isEmpty == true {
            email = Singleton.user.EMAIL
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        date = dateFormatter.string(from: birthdatePicker.date)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let dateForRequest = dateFormatter2.string(from: birthdatePicker.date)
        Singleton.user.BIRTHDATE = dateForRequest
        // if date is not changed, default value
        
        //jsonRequest(fname: fname, lname: lname, email: email, date: birthdatePicker.date)
        
        jsonRequest(fname: fname, lname: lname, email: email, date: dateForRequest)
        
        let alert = UIAlertController(title: "Save Successful!", message: "Your changes have been saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    } // end savePressed
    
    
    func jsonRequest(fname: String, lname: String, email: String, date: String) {
        
        let json: [String: Any] = ["USER_ID": Singleton.user.USER_ID, "EMAIL": email, "PASSWORD": Singleton.user.PASSWORD, "FIRSTNAME": fname, "LASTNAME": lname, "BIRTHDATE": date]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "http://localhost:8080/USERS/UPDATE")!
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
                
                for (key, value) in responseJSON {
                    if key == "entity" {
                        
                        var v = String(describing: value)
                        
                        print("UPDATE: " + v)
                        Singleton.user.EMAIL = email
                        Singleton.user.FIRSTNAME = fname
                        Singleton.user.LASTNAME = lname

                    }
                }
                            
            }
            
        }
        task.resume()
        
    } // end jsonRequest
    

} // end EditViewController
