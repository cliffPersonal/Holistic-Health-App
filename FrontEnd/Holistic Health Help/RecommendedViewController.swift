//
//  RecommendedViewController.swift
//  Holistic Health Help
//
//  Created by Clifford Lin on 4/3/22.
//

import Foundation
import UIKit

class RecommendedViewController: UIViewController{
    
    @IBOutlet weak var recOneLabel: UILabel!
    @IBOutlet weak var recTwoLabel: UILabel!
    override func viewDidLoad() {
        
        recOneLabel.text = "Loading Recommendations..."
        recTwoLabel.text = "Loading Recommendations..."
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.recommendationsRequest()
        print("Rec:")
        print(Singleton.user.RECOMMENDATIONS)
        if(Singleton.user.RECOMMENDATIONS.isEmpty){
            recOneLabel.text = "No Recommendations yet"
            recTwoLabel.text = "No Recommendations yet"
        }
        else{
            var recommendation1 = "For the " + Singleton.user.RECOMMENDATIONS[0].SYMPTOM + " symptom, other users commonly see positive effect of treatment using the " + Singleton.user.RECOMMENDATIONS[0].SUPPLEMENT + " supplement\n\n"
            recOneLabel.text = recommendation1
            
            if(Singleton.user.RECOMMENDATIONS.count > 1){
                var recommendation2 = "For the " + Singleton.user.RECOMMENDATIONS[1].SYMPTOM + " symptom, other users commonly see positive effect of treatment using the " + Singleton.user.RECOMMENDATIONS[1].SUPPLEMENT + " supplement\n\n"
                recTwoLabel.text = recommendation2
            }
            recTwoLabel.text = "No Second Recommendation"
        }
    }

    func recommendationsRequest() {
        
        let json: [String: Any] = ["USER_ID": Singleton.user.USER_ID, "EMAIL": Singleton.user.EMAIL, "PASSWORD": Singleton.user.PASSWORD, "FIRSTNAME": Singleton.user.FIRSTNAME, "LASTNAME": Singleton.user.LASTNAME, "BIRTHDATE": Singleton.user.BIRTHDATE]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "http://localhost:8080/RECOMMENDATIONS")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
                
                for (key, value) in responseJSON {

                    if key == "entity" {
                        
                        var v = String(describing: value)
                        
                        // PARSE THE JSON
                        var cs = CharacterSet.init(charactersIn: "recommendations: { }")
                        v = v.trimmingCharacters(in: cs)
                        cs = CharacterSet.init(charactersIn: "\n\tresult =     ( );")
                        v = v.trimmingCharacters(in: cs)
                        cs = CharacterSet.init(charactersIn: "\"{\" \"}")
                        v = v.trimmingCharacters(in: cs)
                        let pairs = v.components(separatedBy: ",")
                        var supplements:[String] = []
                        var symptoms:[String] = []
                        
                        for pair in pairs {
                            let pairParts = pair.components(separatedBy: ":")
                            if pairParts[0].contains("SUPPLEMENT") == true {
                                cs = CharacterSet.init(charactersIn: "\\\"")
                                let s = pairParts[1].trimmingCharacters(in: cs)
                                supplements.append(s)
                            } else {
                                cs = CharacterSet.init(charactersIn: "\\\"")
                                var s = pairParts[1].trimmingCharacters(in: cs)
                                cs = CharacterSet.init(charactersIn: "}\"")
                                s = s.trimmingCharacters(in: cs)
                                cs = CharacterSet.init(charactersIn: "\\")
                                s = s.trimmingCharacters(in: cs)
                                symptoms.append(s)
                            }
                        }
                        
                        var i = 0
                        for sup in supplements {
                            let rec = Recommendation(SUPPLEMENT: sup, SYMPTOM: symptoms[i])
                            Singleton.user.RECOMMENDATIONS.append(rec)
                            i += 1
                        }
                        print(Singleton.user.RECOMMENDATIONS)
                        

                    }
                }
                            
            }
            
        }
        task.resume()
        sem.wait()
        
        
        
    } // end recommendationsRequest
    
    
    
    
    
}
