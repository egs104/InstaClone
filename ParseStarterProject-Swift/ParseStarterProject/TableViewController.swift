//
//  TableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Eric Suarez on 10/14/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController {
    
    var usernames = [""]
    var userIds = [""]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var query = PFUser.query()
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let users = objects {
                
                self.usernames.removeAll(keepCapacity: true)
                self.userIds.removeAll(keepCapacity: true)
                
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        if user.objectId! != PFUser.currentUser()?.objectId {
                        
                        self.usernames.append(user.username!)
                        self.userIds.append(user.objectId!)
                            
                        }
                        
                    }
                    
                }
                
            }
            
            print(self.usernames)
            print(self.userIds)
            
            self.tableView.reloadData()
        })
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!

         cell.textLabel?.text = usernames[indexPath.row]

        return cell
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark                 //checkmark for people user is following
        
        var following = PFObject(className: "followers")                    //created followers class in parse
        following["following"] = userIds[indexPath.row]                     //following string is the objectId of the person who user wants to follow
        following["follower"] = PFUser.currentUser()?.objectId              //follower string is objectId of the logged in user
        
        following.saveInBackground()
        
    }

}
