//
//  FavoritesTableViewController.swift
//
//  Team Members: Sid Rath (sidrath@iu.edu)
//                Diego Rios-Rojas (dariosro@iu.edu)
//                Shaun Trimm (strimm@iu.edu)
//  Project Name: Involve
//  Final Project Submission Date: May 4, 2021
//

import UIKit

class FavoritesTableViewController: UITableViewController {

    override func viewDidLoad() {
        //super.viewDidLoad()
        super.viewDidAppear(false)
        self.tableView.reloadData()
        self.tableView.rowHeight = 100

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let lAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let lInvolveModel = lAppDelegate.involveModel
            
        return lInvolveModel.favoriteEvents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoritesTableViewCell
        let lAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let lInvolveModel = lAppDelegate.involveModel
        
        let cellEvents = lInvolveModel.favoriteEvents
        
        cell.eventName.text = cellEvents[indexPath.row].name
        cell.eventHost.text = cellEvents[indexPath.row].org.name

        
        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let lInvolveModel = lAppDelegate.involveModel
        let cellEvents = lInvolveModel.favoriteEvents
        
        let eventViewController = storyboard?.instantiateViewController(identifier: "ViewController") as? EventViewController
        eventViewController?.eventNameFromTable = cellEvents[indexPath.row].name
        eventViewController?.eventHostFromTable = cellEvents[indexPath.row].org
        eventViewController?.eventDateFromTable = cellEvents[indexPath.row].time
        eventViewController?.eventDetailsFromTable = cellEvents[indexPath.row].details
        self.navigationController?.pushViewController(eventViewController!, animated: true)
    }

    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
