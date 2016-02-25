//
//  ViewController.swift
//  CustomCalendar
//
//  Created by RujuRaj on 2/24/16.
//  Copyright © 2016 RujuRaj. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    var tableView: UITableView  =   UITableView()
    let screenSize = UIScreen.mainScreen().bounds
    
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /*let weeks: [String] = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
        var i=0
        for day in weeks
        {
            let myFirstLabel = UILabel()
            myFirstLabel.text = day
            myFirstLabel.frame = CGRectMake((CGFloat)(i*50), 0, 80, 50)
            self.view.addSubview(myFirstLabel)
            i++
        }*/
        loadmytable()
        
       /* let myFirstButton = UIButton()
       
        myFirstButton.setTitle("✸", forState: .Normal)
        myFirstButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        myFirstButton.frame = CGRectMake(15, -50, 300, 500)
        myFirstButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(myFirstButton)*/
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
        //return self.items.count
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        if(indexPath.row==0)
        {
            var lblWidth=(screenSize.width-screenSize.width/7)/7
            let weeks: [String] = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
            var j=0
            for day in weeks
            {
                let myFirstLabel = UILabel()
                myFirstLabel.text = day
                myFirstLabel.frame =  CGRectMake((lblWidth+9)*CGFloat(j), 0, lblWidth, 40)
                cell.addSubview(myFirstLabel)
                j=j+1
            }
        }
        else
        {
            var btnWidth=(screenSize.width-screenSize.width/7)/7
            for i in 0...6
            {
                let myFirstButton = UIButton()
                myFirstButton.setTitle("11", forState: .Normal)
                myFirstButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
                if(i==0)
                {
                    myFirstButton.frame = CGRectMake(0, 0, btnWidth, 40)
                }
                else
                {
                    myFirstButton.frame = CGRectMake((btnWidth+8)*CGFloat(i), 0, btnWidth, 40)
                }
                
                myFirstButton.backgroundColor=UIColor.grayColor()
                
                myFirstButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                myFirstButton.layer.cornerRadius=20
                
                cell.addSubview(myFirstButton)
            }
        }
        return cell
        
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

