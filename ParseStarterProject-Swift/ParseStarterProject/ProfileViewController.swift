//
//  ProfileTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Eric Suarez on 10/21/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileTitle: UINavigationItem!
    
    var captions = [String]()
    var users = [String]()
    var imageFiles = [PFFile]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        super.viewDidLoad()
        
        profileTitle.title = selectedFriend
        
        var getFriendsImagesQuery = PFQuery(className:"Post")
        getFriendsImagesQuery.whereKey("userId", equalTo: selectedUserId)
        
        getFriendsImagesQuery.findObjectsInBackgroundWithBlock{ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    self.captions.append(object["caption"] as! (String))
                    
                    self.imageFiles.append(object["imageFile"] as! (PFFile))
                    
                    self.tableView.reloadData()
                }
                
            }
            
        }
        
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(captions)
        print(imageFiles)
        return imageFiles.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! cell
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock{ (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!) {

                myCell.postedImage.image = downloadedImage
                
            }
            
        }

        myCell.username.text = selectedFriend
        myCell.caption.text = captions[indexPath.row]
        return myCell
    }
    
    
    
//    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
//    {
//        retu rn 44
//    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
