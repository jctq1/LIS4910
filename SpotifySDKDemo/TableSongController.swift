//
//  TableSongController.swift
//  SpotifySDKDemo
//
//  Created by Jose Carlos Torres Quiles on 3/29/18.
//  Copyright © 2018 Elon Rubin. All rights reserved.
//

import UIKit

class MusicData{
    let name : String
    let album : String
    let artist : String
    let type : String
    let photo : UIImage
    let id : String
    
    init(photo: UIImage, name: String, album: String, artist: String, type: String, id: String) {
        self.name = name
        self.photo = photo
        self.id = id
        self.album = album
        self.artist = artist
        self.type = type
    }
}

class SongCell : UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var album: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var cover: UIImageView!
    
}

var referencesearchsongs : TableSongController? = nil
var songtoadd : String? = nil

class TableSongController: UITableViewController {
    
    var list = [MusicData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        referencesearchsongs = self

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
        return list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songcell", for: indexPath) as! SongCell
        let row = indexPath.row
        cell.album.text = list[row].album
        cell.artist.text = list[row].artist
        cell.name.text = list[row].name
        cell.type.text = list[row].type
        cell.cover.image = list[row].photo

        return cell
    }
    
    func updateData(list: [MusicData]) {
        self.list = list
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = list[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShowSong") as! ShowSongViewController
        vc.song = song
        songtoadd = song.id
        present(vc, animated: true, completion: nil)
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
