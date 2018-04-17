//
//  HomeGenericViewViewController.swift
//  SpotifySDKDemo
//
//  Created by Tallafoc on 4/3/18.
//  Copyright © 2018 Elon Rubin. All rights reserved.
//

import UIKit
import SafariServices
import AVFoundation
import Spartan

class HomeGenericViewViewController: GenericViewController {
    @IBOutlet weak var username: UILabel!
    
    func setNews(){
        Spartan.getRecommendations(limit: 20, market: CountryCode.us, minAttributes: [(TuneableTrackAttribute.danceability,0.6),(TuneableTrackAttribute.energy,0.6),(TuneableTrackAttribute.popularity,60)], maxAttributes: nil, targetAttributes: nil, seedArtists: nil, seedGenres: ["party,techno,pop"], seedTracks: nil, success: { (recom) in
            var tracks = recom.tracks
            let fin = tracks?.map{$0.id}
            Spartan.getTracks(ids: fin as! [String], success: { (fin) in
                var fill = [MusicData]()
                for item in fin{
                    let url = URL(string: item.album.images[0].url)
                    let image = UIImage(data: (NSData(contentsOf: url!)! as Data))
                    let duration = item.durationMs
                    let name = item.name
                    let data = MusicData(photo: image!, name: item.name, album: item.album.name, artist: item.artists[0].name, type: "song", id: item.id as! String)
                    fill += [data]
                }
                referencesearchsongs?.updateData(list: fill)
            }, failure: { (error) in
                print(error)
            })
            
        }, failure: { (error) in
            print(error)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNews()
        /*SPTUser.request(session!.canonicalUsername, withAccessToken: session?.accessToken, callback: { (error, result) in
            if let profile = result as? SPTUser {
                self.username.text = "Hey \(profile.canonicalUserName)"
            } else {
                self.username.text = "Hey generic"
            }
        })*/
        self.username.text = "Your news feed!"
        
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
