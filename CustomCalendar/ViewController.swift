//
//  ViewController.swift
//  CustomCalendar
//
//  Created by RujuRaj on 2/24/16.
//  Copyright © 2016 RujuRaj. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    //@IBOutlet weak var tblv: UITableView!
    var tableView: UITableView  =   UITableView()
    let screenSize = UIScreen.mainScreen().bounds
    var daysOfMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    var month=0, currentDay=0,weekday=0,year=0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupDates(-1)
        loadmytable()
    }
    func setupDates(currentMonth:Int)
    {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year,.Weekday], fromDate: date)
        year =  components.year
        if(year%4==0)
        {
            daysOfMonth[1]=29
        }
        if(currentMonth == -1)
        {
            month=components.month-1
        }
        else
        {
            month = currentMonth//components.month-1 // current month based on index 0
        }
        
        currentDay = components.day
        weekday=components.weekday-1 // current weekday number based on index 1
        var totalDaysInMonth=daysOfMonth[month]
        firstWeekDay=weekday-(currentDay%7-1)
        
        if(firstWeekDay != 1)
        {
            index=daysOfMonth[month-1]-firstWeekDay+2
        }

    }
    
    func loadmytable()
    {
        tableView.frame         =   CGRectMake(4, 50, screenSize.width, screenSize.height/2);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    var index=1
    var starty=0 as CGFloat
    var firstWeekDay = 1
    func prevClicked(sender:UIButton!)
    {
        month--;
        index=1
        
        firstWeekDay=weekday-(currentDay%7-1)
        self.tableView.reloadData()
    }
    func nextClicked(sender:UIButton!)
    {
        month++;
        index=1
        self.tableView.reloadData()
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        let btnWidth=(screenSize.width-screenSize.width/7)/7
        if(indexPath.row==0)
        {
            let btnSize=30 as CGFloat
            let prevBtn = UIButton()
            prevBtn.setTitle("<", forState: .Normal)
            prevBtn.frame = CGRectMake(5, starty, btnSize, btnSize)
            prevBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
            prevBtn.backgroundColor=UIColor.greenColor()
            prevBtn.addTarget(self, action: "prevClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.addSubview(prevBtn)
            
            let nextBtn = UIButton()
            nextBtn.setTitle(">", forState: .Normal)
            nextBtn.frame = CGRectMake(65, starty, btnSize, btnSize)
            nextBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
            nextBtn.backgroundColor=UIColor.greenColor()
            nextBtn.addTarget(self, action: "nextClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.addSubview(nextBtn)
        }
        else if(indexPath.row==1)
        {
            let lblWidth=(screenSize.width-screenSize.width/7)/7
            let weeks: [String] = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
            var j=0
            for day in weeks
            {
                let myFirstLabel = UILabel()
                myFirstLabel.text = day
                myFirstLabel.frame =  CGRectMake((lblWidth+9)*CGFloat(j), starty, lblWidth, 40)
                cell.addSubview(myFirstLabel)
                j=j+1
                
            }
        }
        else
        {
            
            for i in 0...6
            {
                let dayBtn = UIButton()
                dayBtn.setTitle(String(index), forState: .Normal)
                dayBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
                
                dayBtn.frame = CGRectMake((btnWidth+8)*CGFloat(i), starty, btnWidth, 40)
                dayBtn.backgroundColor=UIColor.grayColor()
                
                dayBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                dayBtn.layer.cornerRadius=20
                dayBtn.addTarget(self, action: "dayClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                cell.addSubview(dayBtn)
                index=index+1
                if(firstWeekDay != 1)
                {
                    if(index>daysOfMonth[month-1])
                    {
                        index=1
                        firstWeekDay=1
                    }
                }
                else
                {
                    if(index>daysOfMonth[month])
                    {
                        index=1
                    }
                }
            }
        }
        return cell
    }
    
    
    
    var savedEventId : String = ""
    
    func dayClicked(sender:UIButton!)
    {
        let eventStore = EKEventStore()
        
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) -> Void in
                self.deleteEvent(eventStore, eventIdentifier: self.savedEventId)
            })
        }
        else
        {
            
            readEvents(eventStore,day: Int(sender.currentTitle!)!)
        }

    }
    
    func readEvents(eventStore: EKEventStore,day:Int)
    {
        /*let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let startDate = formatter.dateFromString("\(year)/\(month+1)/\(day)")*/
        
        
        var myCalendar: NSCalendar = NSCalendar.currentCalendar()
        
        let oneDayAgoComponents: NSDateComponents = NSDateComponents()
        oneDayAgoComponents.day = day-currentDay
        oneDayAgoComponents.timeZone=NSTimeZone.localTimeZone()
        var startDate: NSDate = myCalendar.dateByAddingComponents(oneDayAgoComponents,
                                                                  toDate: NSDate(),
                                                                  options: NSCalendarOptions())!
        
        
        
        let oneYearFromNowComponents: NSDateComponents = NSDateComponents()
        oneYearFromNowComponents.day = day-currentDay+1
        var myendDate: NSDate = myCalendar.dateByAddingComponents(oneYearFromNowComponents,
                                                                       toDate: NSDate(),
                                                                       options: NSCalendarOptions())!
        
        /*if(day>currentDay)
        {
            var tempDate=startDate
            startDate=myendDate
            myendDate=tempDate
        }*/
        
        let myEventStore = EKEventStore()
        var predicate = NSPredicate()
        
       
        predicate = myEventStore.predicateForEventsWithStartDate(startDate,
                                                                 endDate: myendDate,
                                                                 calendars: nil)
        
        var events = myEventStore.eventsMatchingPredicate(predicate) as! [EKEvent]
        var eventItems = [String]()
        if !events.isEmpty {
            for i in events{
                print(i.title)
                print(i.startDate)
                print(i.endDate)
                
                eventItems += ["\(i.title): \(i.startDate)"]
            }
        }
        
    }
    func deleteEvent(eventStore: EKEventStore, eventIdentifier: String) {
        let eventToRemove = eventStore.eventWithIdentifier(eventIdentifier)
        if (eventToRemove != nil)
        {
            do
            {
                try eventStore.removeEvent(eventToRemove!, span: .ThisEvent)
            }
            catch {
                print("Bad things happened")
            }
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   /* func pressed(sender: UIButton!) {
        var alertView = UIAlertView();
        alertView.addButtonWithTitle("Ok");
        alertView.title = "title";
        alertView.message = "message";
        alertView.show();
    }*/
}

