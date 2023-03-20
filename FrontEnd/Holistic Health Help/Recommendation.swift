//
//  Recommendation.swift
//  Holistic Health Help
//
//  Created by Judy Song on 4/22/22.
//

import Foundation

struct Recommendation {
    
    var SUPPLEMENT: String
    var SYMPTOM: String
    // var DOSAGE: String
    
    func getDetails() {
        print("For the \(SYMPTOM) symptom, other users have commonly seens positive effect of treatment using the \(SUPPLEMENT) supplement")
    }

}
