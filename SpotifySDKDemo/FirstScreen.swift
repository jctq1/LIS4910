//
//  FirstScreen.swift
//  SpotifySDKDemo
//
//  Created by Jose Carlos Torres Quiles on 3/26/18.
//  Copyright © 2018 Elon Rubin. All rights reserved.
//

import UIKit
import SafariServices
import AVFoundation


class FirstScreen: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
  
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var songname: UITextField!
    @IBOutlet weak var photo: UIImageView!
    @objc var auth = SPTAuth.defaultInstance()!
    @objc var session:SPTSession!
    @objc var player: SPTAudioStreamingController?
    
    
    
    @objc func initializaPlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player?.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
            
        }
        
    }

    @objc func updateAfterFirstLogin(){
        let userDefaults = UserDefaults.standard
        
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializaPlayer(authSession: self.session)
            SPTUser.request(session.canonicalUsername, withAccessToken: session.accessToken, callback: { (error, result) in
                if let profile = result as? SPTUser {
                    self.username.text = "Hey \(profile.displayName!)"
                } else {
                    self.username.text = "Hey generic"
                }
            })
        }
        else {
            self.username.text = "Error retrieving fields"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(FirstScreen.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playStop(_ sender: Any) {
        if (self.player?.playbackState.isPlaying)! {
            self.player?.setIsPlaying(false, callback: nil)
        } else {
            self.player?.setIsPlaying(true, callback: nil)
        }
    }
    
    func changesong(id: String) {
        self.player?.playSpotifyURI("spotify:track:\(id)", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
            
        })
        self.player?.setIsPlaying(false, callback: nil)
    }
    
    @IBAction func searchSong(_ sender: Any) {
        let text = songname.text!
        let querytipe = SPTSearchQueryType.queryTypeTrack
        SPTSearch.perform(withQuery: text, queryType: querytipe, accessToken: session.accessToken) { (error, result) in
            if (result != nil){
                let results = result as! SPTListPage
                let items = results.tracksForPlayback()
                let casteditems = items! as! [SPTPartialTrack]
                let firstitem = casteditems[0].identifier
                self.changesong(id: firstitem!)
                //self.song.text = casteditems[0].name
                let url = (casteditems[0].album.covers as! [SPTImage])[1].imageURL
                print(casteditems[0].sharingURL!)
                self.photo.image = UIImage(data: NSData(contentsOf: url!)! as Data)
            }
            else {
                print(error.debugDescription)
            }
        }
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
