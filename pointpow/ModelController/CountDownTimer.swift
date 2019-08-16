//
//  CountDownTimer.swift
//  pointpow
//
//  Created by thanawat on 1/4/2562 BE.
//  Copyright © 2562 abcpoint. All rights reserved.
//

import Foundation



func defaultUpdateActionHandler(data:(days:String, hours:String, minutes:String, seconds:String))->(){
    
}

func defaultCompletionActionHandler()->(){
    
}

public class DateCountDownTimer{
    
    var running = false
    var countdownTimer: Timer?
    var totalTime = 60
    var dateString = "March 4, 2018 13:20:10" as String
    var UpdateActionHandler:((days:String, hours:String, minutes:String, seconds:String))->() = defaultUpdateActionHandler
    var CompletionActionHandler:()->() = defaultCompletionActionHandler
    
    public init(){
        running = false
        countdownTimer = Timer()
        totalTime = 60
        dateString = "March 4, 2018 13:20:10" as String
        UpdateActionHandler = defaultUpdateActionHandler
        CompletionActionHandler = defaultCompletionActionHandler
    }
    
    public func initializeTimer(_ dateString:String){
        
        // Setting Today's Date
        let currentDate = Date()
        
        // Setting TargetDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en")
        if let targedDate = dateFormatter.date(from: dateString) {
            // Calculating the difference of dates for timer
            let calendar = NSCalendar.current
            let unitFlags: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year]
            let component = calendar.dateComponents(unitFlags, from: currentDate, to: targedDate)
            let days = component.day!
            let hours = component.hour!
            let minutes = component.minute!
            let seconds = component.second!
            totalTime = hours * 60 * 60 + minutes * 60 + seconds
            totalTime = days * 60 * 60 * 24 + totalTime
            
            if totalTime < 0 {
                totalTime = 0
            }
        }
        
        
    }
    
    func numberOfDaysInMonth(month:Int) -> Int{
        let dateComponents = DateComponents(year: 2015, month: 7)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        print(numDays)
        return numDays
    }
    
    var timeInterVal = 1.0
    
    public func startTimer(pUpdateActionHandler:@escaping ((days:String, hours:String, minutes:String, seconds:String))->(),pCompletionActionHandler:@escaping ()->()) {
       
        
        self.CompletionActionHandler = pCompletionActionHandler
        self.UpdateActionHandler = pUpdateActionHandler
        
        
        countdownTimer = Timer.scheduledTimer(timeInterval: self.timeInterVal, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        RunLoop.main.add(countdownTimer!, forMode: RunLoop.Mode.common)
        
        
        
        self.running = true
    }
    
    @objc func updateTime() {
        if totalTime > 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
        
        self.UpdateActionHandler(timeFormatted(totalTime))
        
        
        
    }
    
    func endTimer() {
        self.running = false
        self.CompletionActionHandler()
        countdownTimer?.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> (days:String, hours:String, minutes:String, seconds:String) {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = (totalSeconds / 60 / 60) % 24
        let days: Int = (totalSeconds / 60 / 60 / 24)
        
        //let data:(days:String, hours:String, minutes:String, seconds:String) = (days:)
        
        //return String(format: "%dD %02dH %02dM %02dS", days, hours, minutes, seconds)
        
        return (days:String(format: "%02d",  days),
                hours:String(format: "%02d", hours),
                minutes:String(format: "%02d",  minutes),
                seconds:String(format: "%02d",  seconds))
    }
    
}
