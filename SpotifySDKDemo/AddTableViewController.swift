//
//  AddTableViewController.swift
//  SpotifySDKDemo
//
//  Created by Jose Carlos Torres Quiles on 3/29/18.
//  Copyright © 2018 Elon Rubin. All rights reserved.
//

import UIKit

class AddCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var added: UIImageView!
}

var referenceadd : AddTableViewController? = nil

class AddTableViewController: UITableViewController {
    
    var parties = [Party]()

    override func viewDidLoad() {
        super.viewDidLoad()
        referenceadd = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func reloadData(parties : [Party]){
        self.parties = parties
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return parties.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addcell", for: indexPath) as! AddCell

        cell.name.text = parties[indexPath.row].name
        if let id = songtoadd {
            if (Song.isOnParty(id: id, party: parties[indexPath.row])){
                cell.added.image = #imageLiteral(resourceName: "checked-checkbox")
            }
            else {
                cell.added.image = #imageLiteral(resourceName: "more_format_indent_users_plus-512")
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = parties[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "addcell", for: indexPath) as! AddCell
        if (cell.added.image == #imageLiteral(resourceName: "more_format_indent_users_plus-512")){
            Song.vote(song: songtoadd!, party: row.id, userid: (session?.canonicalUsername)!, vote: 1)
            cell.added.image = #imageLiteral(resourceName: "checked-checkbox")
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
        else {
            // DO NOTHING
        }
        
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
