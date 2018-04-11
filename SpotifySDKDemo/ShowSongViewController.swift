//
//  ShowSongViewController.swift
//  SpotifySDKDemo
//
//  Created by Carlos Quiles on 4/11/18.
//  Copyright © 2018 Elon Rubin. All rights reserved.
//

import UIKit


class ShowSongViewController: GenericViewController {
    
    var song: MusicData? = nil

    @IBOutlet weak var songtitle: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBAction func playSong(_ sender: Any) {
        //TODO
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let music = song {
            songtitle.text = music.name + " by " + music.artist
            cover.image = music.photo
        }
        
        var parties = Party.returnOwnedParties(id: (session?.canonicalUsername)!)
        parties += Party.returnSubscribedParties(id: (session?.canonicalUsername)!)
        referenceadd?.reloadData(parties: parties)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
