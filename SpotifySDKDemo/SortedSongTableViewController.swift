//
//  SortedSongTableViewController.swift
//  SpotifySDKDemo
//
//  Created by Jose Carlos Torres Quiles on 3/29/18.
//  Copyright © 2018 Elon Rubin. All rights reserved.
//

import UIKit

class upvote: UIImageView {
    
}

class downvote: UIImageView {
    
}

class SortedSongCell : UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var balancevotes: UILabel!
    @IBOutlet weak var upvote: UIImageView!
    @IBOutlet weak var downvote: UIImageView!
    @IBOutlet weak var downvotecon: UIView!
    @IBOutlet weak var upvotecon: UIView!
    
    @IBOutlet weak var cover: UIImageView!
    
    var id : String? = nil
    var duration: Int? = nil
    var enabled = true
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let first = touches.first!
        if (first.view == upvotecon && downvote.image != #imageLiteral(resourceName: "Vote_down_grey") && enabled){
            Song.vote(song: id!, party: (referenceplayer?.party?.id)!, userid: (session?.canonicalUsername)!, vote: 1)
            balancevotes.text = String(Song.getVotes(idparty: (referenceplayer?.party?.id)!, idsong: id!))
            downvote.image = #imageLiteral(resourceName: "Vote_down_grey")
            upvote.image = #imageLiteral(resourceName: "Vote_up")
        }
        else if (first.view == downvotecon && upvote.image != #imageLiteral(resourceName: "Vote_up_grey") && enabled) {
            Song.vote(song: id!, party: (referenceplayer?.party?.id)!, userid: (session?.canonicalUsername)!, vote: 0)
            balancevotes.text = String(Song.getVotes(idparty: (referenceplayer?.party?.id)!, idsong: id!))
            upvote.image = #imageLiteral(resourceName: "Vote_up_grey")
            downvote.image = #imageLiteral(resourceName: "Vote_down")
        }
        else if (first.view != downvotecon && first.view != upvotecon && enabled && (referenceplayer?.isowner)!){
            referenceplayer?.changesong(id: id!, duration: duration!)
            referenceplayer?.coverbig.image = cover.image
            referenceplayer?.song.text = title.text
        }
        self.reloadInputViews()
    }
}

var sortedsongs : SortedSongTableViewController? = nil

class SortedSongTableViewController: UITableViewController {

    var songs = [MusicPropierties]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortedsongs = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return songs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sortedsongcell", for: indexPath) as! SortedSongCell

        let res = Song.itVoted(songid: songs[indexPath.row].id, partyid: (referenceplayer?.party?.id)!, id: (session?.canonicalUsername)!)
        if (res == 1){
            cell.downvote.image = #imageLiteral(resourceName: "Vote_down_grey")
            cell.upvote.image = #imageLiteral(resourceName: "Vote_up")
        }
        else  if (res == 0) {
            cell.upvote.image = #imageLiteral(resourceName: "Vote_up_grey")
            cell.downvote.image = #imageLiteral(resourceName: "Vote_down")
        }
        else {
            cell.upvote.image = #imageLiteral(resourceName: "Vote_up")
            cell.downvote.image = #imageLiteral(resourceName: "Vote_down")
        }
        cell.balancevotes.text = String(describing: songs[indexPath.row].votes)
        cell.title.text = songs[indexPath.row].name
        cell.id = songs[indexPath.row].id
        cell.duration = songs[indexPath.row].duration
        cell.cover.image = songs[indexPath.row].photo
        if (songs[indexPath.row].played){
            cell.enabled = false
            cell.backgroundColor = UIColor.gray.withAlphaComponent(0)
        }
        return cell
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
