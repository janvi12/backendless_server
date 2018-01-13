//
//  ViewController.swift
//  backendless_server
//
//  Created by Harshul Shah on 13/01/18.
//  Copyright © 2018 Harshul Shah. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var tableView: UITableView!
    let backendless = Backendless.sharedInstance()!
    
    var aryData = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dataStore = backendless.data.ofTable("user")
        aryData = (dataStore?.find()!)! as NSArray
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSubmit(_ sender: AnyObject)
    {
        // Saving user object in the user table
        let dicData = NSMutableDictionary()
        dicData.setObject(txtFirstName.text!, forKey: "first_name" as NSCopying)
        dicData.setObject(txtLastName.text!, forKey: "last_name" as NSCopying)
        
       // let testObject = ["id": "1", "first_name" : "jahanvi", "last_name" :  "Trivedi"];
        let dataStore = backendless.data.ofTable("user")
        dataStore?.save(dicData,
                        response: {
                            (result) -> () in
                            print("Object is saved in Backendless. Please check in the console.")
                            self.view.endEditing(true)
                            let dataStore = self.backendless.data.ofTable("user")
                            self.aryData = (dataStore?.find()!)! as NSArray
                            self.tableView.reloadData()
        },
                        error: {
                            (fault : Fault?) -> () in
                            print("Server reported an error: \(String(describing: fault))")
        })
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CELL")
        
        let dicData: NSDictionary = aryData.object(at: indexPath.row) as! NSDictionary
        cell.textLabel?.text = dicData.value(forKey: "first_name") as? String
        cell.detailTextLabel?.text = dicData.value(forKey: "last_name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if(editingStyle == .delete)
        {
            let dicData: NSDictionary = aryData.object(at: indexPath.row) as! NSDictionary
            let strobjectId: String = dicData.value(forKey: "objectId") as! String
            let dataStore = backendless.data.ofTable("user")
            
            dataStore?.remove(byId: strobjectId, response: {
                (result) -> () in
                print("Object is delted in Backendless. Please check in the console.")
                let dataStore = self.backendless.data.ofTable("user")
                self.aryData = (dataStore?.find()!)! as NSArray
                self.tableView.reloadData()
            },
                              error: {
                (fault : Fault?) -> () in
                print("Server reported an error: \(String(describing: fault))")
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dicData: NSDictionary = aryData.object(at: indexPath.row) as! NSDictionary
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "updateView") as! UpdateViewController
        secondViewController.dicData = dicData
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
}
