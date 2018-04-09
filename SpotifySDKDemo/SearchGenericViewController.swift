//
//  SearchGenericViewController.swift
//  SpotifySDKDemo
//
//  Created by Tallafoc on 4/4/18.
//  Copyright © 2018 Elon Rubin. All rights reserved.
//

import UIKit

class SearchGenericViewController: GenericViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let text = textField.text!
        let querytipe = SPTSearchQueryType.queryTypeTrack
        SPTSearch.perform(withQuery: text, queryType: querytipe, accessToken: referencemain?.session.accessToken) { (error, result) in
            if (result != nil){
                var list = [MusicData]()
                let results = result as! SPTListPage
                let items = results.items
                let casteditems = items! as! [SPTPartialTrack]
                for item in casteditems {
                    let url = (item.album.covers as! [SPTImage])[1].imageURL
                    let image = UIImage(data: NSData(contentsOf: url!)! as Data)
                    let album = item.album.name
                    let name = item.name
                    let id = item.identifier
                    let artist = (item.artists as! [SPTPartialArtist]).first!.name
                    let newcell = MusicData(photo: image!, name: name!, album: album!, artist: artist!, type: "Song", id: id!)
                    list += [newcell]
                }
                //let firstitem = casteditems[0].identifier
                //self.changesong(id: firstitem!)
                // self.songlist.dataSource = casteditems
                //self.song.text = casteditems[0].name
                referencesearchsongs?.updateData(list: list)
                
            }
            else {
                print(error.debugDescription)
            }
            //table.tableView.reloadData()
        }
        
        textField.resignFirstResponder()  //if desired
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
