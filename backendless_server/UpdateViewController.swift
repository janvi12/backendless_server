//
//  UpdateViewController.swift
//  backendless_server
//
//  Created by Harshul Shah on 13/01/18.
//  Copyright © 2018 Harshul Shah. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController
{
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    var dicData = NSDictionary()
    let backendless = Backendless.sharedInstance()!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(dicData)
        
        txtFirstName.text = dicData.value(forKey: "first_name") as? String
        txtLastName.text = dicData.value(forKey: "last_name") as? String
    }
    
    @IBAction func btnUpdate(_ sender: AnyObject)
    {
        let objectId: String = dicData.value(forKey: "objectId") as! String
        print(objectId)
        
        // Update user object in the user table
        let dicUpdateData = NSMutableDictionary()
        dicUpdateData.setObject(txtFirstName.text!, forKey: "first_name" as NSCopying)
        dicUpdateData.setObject(txtLastName.text!, forKey: "last_name" as NSCopying)
        dicUpdateData.setObject(objectId, forKey: "objectId" as NSCopying)
        
        let dataStore = backendless.data.ofTable("user")
        
        dataStore?.save(dicUpdateData, response: {
            (result) -> () in
            print("Object is updated in Backendless. Please check in the console.")
        }, error: {
            (fault : Fault?) -> () in
            print("Server reported an error: \(String(describing: fault))")
        })
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
