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
    
    var usernames = [""]                    //array of usernames
    var userIds = [""]                      //array of unique user object ids
    var isFollowing = ["":false]            //dictionary of object ids and bool indicating whether they are being followed

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
                self.isFollowing.removeAll(keepCapacity: true)
                
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        if user.objectId! != PFUser.currentUser()?.objectId {
                        
                            self.usernames.append(user.username!)
                            self.userIds.append(user.objectId!)
                            
                            var query = PFQuery(className: "followers")
                            
                            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                
                                if let objects = objects {
                                    
                                    if objects.count > 0 {
                                    
                                        self.isFollowing[user.objectId!] = true
                                    
                                    } else {
                                    
                                        self.isFollowing[user.objectId!] = false
                                    
                                    }
                                }
                                
                                if self.isFollowing.count == self.usernames.count {
                                    
                                    self.tableView.reloadData()
                                    
                                }
                            
                            })
                
                        }
                        
                    }
                }
            }
            
            print(self.usernames)
            print(self.userIds)
                        
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
        
        let FollowedObjectId = userIds[indexPath.row]
        
        if isFollowing[FollowedObjectId] == true {
            
             cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        }

        return cell
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        let FollowedObjectId = userIds[indexPath.row]
        
        if isFollowing[FollowedObjectId] == false {
            
            isFollowing[FollowedObjectId] = true
        
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark                 //checkmark for people user is following
        
            var following = PFObject(className: "followers")                    //created followers class in parse
            following["following"] = userIds[indexPath.row]                     //following string is the objectId of the person who user wants to follow
            following["follower"] = PFUser.currentUser()?.objectId              //follower string is objectId of the logged in user
        
            following.saveInBackground()
            
        } else {
            
            isFollowing[FollowedObjectId] = false
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            var query = PFQuery(className: "followers")
            
            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
            query.whereKey("following", equalTo: userIds[indexPath.row])
            
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                if let objects = objects {
                    
                    for object in objects {
                        
                        object.deleteInBackground()
                        
                    }
                }
                
            })

            
        }
        
    }

}
