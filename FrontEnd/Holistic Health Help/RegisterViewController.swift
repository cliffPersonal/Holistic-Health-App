//
//  RegisterViewController.swift
//  Holistic Health Help
//
//  Created by Clifford Lin on 2/17/22.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var FirstnameTextfield: UITextField!
    @IBOutlet weak var LastnameTextfield: UITextField!
    @IBOutlet weak var EmailTextfield: UITextField!
    @IBOutlet weak var PasswordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func firstnameExit(_ sender: UITextField) {
        FirstnameTextfield.resignFirstResponder()
    }
    @IBAction func lastnameExit(_ sender: UITextField) {
        LastnameTextfield.resignFirstResponder()
    }
    @IBAction func emailExit(_ sender: UITextField) {
        EmailTextfield.resignFirstResponder()
    }
    @IBAction func passwordExit(_ sender: UITextField) {
        PasswordTextfield.resignFirstResponder()
    }
    
    @IBAction func CreateButtonPressed(_ sender: UIButton) {
        
        guard
            let fname = FirstnameTextfield.text,
            let lname = LastnameTextfield.text,
            let email = EmailTextfield.text,
            let password = PasswordTextfield.text
        else { return }
        
        jsonRequest(fname: fname, lname: lname, email: email, password: password)
        
    }
    
    func jsonRequest(fname: String, lname: String, email: String, password: String) {

        let json: [String: Any] = ["USER_ID": 0, "EMAIL": email, "PASSWORD": password, "FIRSTNAME": fname, "LASTNAME": lname, "BIRTHDATE": 0]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://localhost:8080/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
            
        }
        task.resume()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if FirstnameTextfield.text?.isEmpty == true || LastnameTextfield.text?.isEmpty == true || EmailTextfield.text?.isEmpty == true || PasswordTextfield.text?.isEmpty == true {
            
            let alertController = UIAlertController(title: "Login Error", message: "One or more of the fields are empty", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okButton)
            self.present(alertController, animated: true, completion: nil)
            
            return false
        } else {
            return true
        }
    }
    
    
    

} // end RegisterViewController class bracket
