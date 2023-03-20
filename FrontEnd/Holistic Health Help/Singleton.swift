//
//  UserSingleton.swift
//  Holistic Health Help
//
//  Created by Judy Song on 4/13/22.
//

import Foundation

struct DailyLog{
    var DATE: String
    var SUPPLEMENTS: [String]
    var SYMPTOMS: [String]
    var SEVERITIES: [Int]
    
    public init(){
        self.DATE = ""
        self.SUPPLEMENTS = []
        self.SYMPTOMS = []
        self.SEVERITIES = []
    }
    
}

class Singleton {
    static let user = Singleton()
    
    var LOGGEDIN: Bool
    var PASSWORD: String
    var LASTNAME: String
    var USER_ID: Int
    var FIRSTNAME: String
    var BIRTHDATE: String
    var EMAIL: String
    var CONDITIONS: [String]
    var USER_SYMPTOMS: [String]
    var USER_SUPPLEMENTS: [String]
    var LOGS: [DailyLog]
    var RECOMMENDATIONS: [Recommendation]
    var SELECTEDDATE: String
    
    private init() {
        self.LOGGEDIN = false
        self.PASSWORD = ""
        self.LASTNAME = ""
        self.USER_ID = -1
        self.FIRSTNAME = ""
        self.BIRTHDATE = ""
        self.EMAIL = ""
        self.CONDITIONS = []
        self.USER_SYMPTOMS = []
        self.USER_SUPPLEMENTS = []
        self.LOGS = []
        self.RECOMMENDATIONS = []
        self.SELECTEDDATE = ""
    }
    
    func destroy(){
        self.LOGGEDIN = false
        self.PASSWORD = ""
        self.LASTNAME = ""
        self.USER_ID = -1
        self.FIRSTNAME = ""
        self.BIRTHDATE = ""
        self.EMAIL = ""
        self.CONDITIONS = []
        self.USER_SYMPTOMS = []
        self.USER_SUPPLEMENTS = []
        self.LOGS = []
        self.RECOMMENDATIONS = []
        self.SELECTEDDATE = ""
    }
    
}

