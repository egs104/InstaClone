//
//  myProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Eric Suarez on 10/22/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class myProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var captions = [String]()
    var myImageFiles = [PFFile]()
    
    override func viewDidLoad() {
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        super.viewDidLoad()

        var getMyImagesQuery = PFQuery(className:"Post")
        getMyImagesQuery.whereKey("userId", equalTo: (PFUser.currentUser()?.objectId!)!)
        
        getMyImagesQuery.findObjectsInBackgroundWithBlock{ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    self.captions.append(object["caption"] as! (String))
                    
                    self.myImageFiles.append(object["imageFile"] as! (PFFile))
                    
                    self.tableView.reloadData()
                }
                
            }
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields to resign the first responder status.
        view.endEditing(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(captions)
        print(myImageFiles)
        return myImageFiles.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! cell
        
        myImageFiles[indexPath.row].getDataInBackgroundWithBlock{ (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!) {
                
                myCell.myPostedImage.image = downloadedImage
                
            }
            
        }
        
        myCell.myUsername.text = PFUser.currentUser()!.username!
        print(PFUser.currentUser()!.username!)
        myCell.myCaption.text = captions[indexPath.row]
        return myCell
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
