//
//  DailyLogViewController.swift
//  Holistic Health Help
//
//  Created by Clifford Lin on 4/3/22.
//

import Foundation
import UIKit

class DailyLogViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var selectedDate = Date()
    var totalSquares = [String]()
    var dates = [String]()
    var days = [String]()
    var months = [String]()
    var years = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setCellsView()
        setMonthView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dates = []
        for log in Singleton.user.LOGS{
            dates.append(log.DATE)
        }
        
        days = []
        months = []
        years = []
        for date in dates{
            let start = date.index(date.startIndex, offsetBy: 4)
            let end = date.index(date.endIndex, offsetBy: -6)
            let range = start ..< end
            let daySubstring = String(date[range])
            days.append(daySubstring)
            
            let start2 = date.index(date.startIndex, offsetBy: 0)
            let end2 = date.index(date.endIndex, offsetBy: -9)
            let range2 = start2 ..< end2
            let monthSubstring = String(date[range2])
            months.append(monthSubstring)
            
            let start3 = date.index(date.startIndex, offsetBy: 8)
            let end3 = date.index(date.endIndex, offsetBy: 0)
            let range3 = start3 ..< end3
            let yearSubstring = String(date[range3])
            years.append(yearSubstring)
        }
        print("Days:")
        print(days)
    }
    
    func setCellsView()
    {
        let width = (collectionView.frame.size.width - 2)/8
        let height = (collectionView.frame.size.height - 2)/8
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func setMonthView(){
        totalSquares.removeAll()
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        
        var count: Int = 1
        
        while(count <= 42){
            if(count <= startingSpaces || count - startingSpaces > daysInMonth){
                totalSquares.append("")
            }
            else{
                totalSquares.append(String(count - startingSpaces))
            }
            count += 1
        }
        
        monthLabel.text = CalendarHelper().monthString(date: selectedDate) + " " + CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()
    }
    
    @IBAction func previousMonth(_ sender: UIButton) {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMonthView()
    }
    
    @IBAction func nextMonth(_ sender: UIButton) {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        cell.dayOfMonth.setTitle(totalSquares[indexPath.item], for: .normal)
        
        cell.dayOfMonth.isUserInteractionEnabled = false
        cell.dayOfMonth.setTitleColor(UIColor.gray, for: .normal)
        
        var d = totalSquares[indexPath.item]
        if(d.count == 1){
            d = "0" + d
        }
        let m = CalendarHelper().monthString(date: selectedDate)
        let start = m.index(m.startIndex, offsetBy: 0)
        let end = m.index(m.startIndex, offsetBy: 3)
        let range = start ..< end
        let mSub = m[range]
        let y = CalendarHelper().yearString(date: selectedDate)
        
        let dString = mSub + " " + d + ", " + y
        cell.Date = dString
        //print("DString:")
        //print(dString)
        
        for i in 0 ..< days.count{
            if(days[i].contains(d)){
                if(m.contains(months[i])){
                    if(y.contains(years[i])){
                        cell.dayOfMonth.setTitleColor(UIColor.blue, for: .normal)
                        cell.dayOfMonth.isUserInteractionEnabled = true
                    }
                }
            }
        }
        return cell
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
