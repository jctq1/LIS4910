//
//  ViewController.swift
//  SpotifySDKDemo
//
//  Created by Elon Rubin on 2/16/17.
//  Copyright © 2017 Elon Rubin. All rights reserved.
//

import UIKit
import SafariServices
import AVFoundation



class MainViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {

    //--------------------------------------
    // MARK: Variables
    //--------------------------------------
    
    // Variables
    @objc var auth = SPTAuth.defaultInstance()!
    @objc var session:SPTSession!
    
    // Initialzed in either updateAfterFirstLogin: (if first time login) or in viewDidLoad (when there is a check for a session object in User Defaults
    @objc var player: SPTAudioStreamingController?
    @objc var loginUrl: URL?
    
    
    //--------------------------------------
    // MARK: Outlets
    //--------------------------------------
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var playStopButton: UISwitch!
    
    //--------------------------------------
    // MARK: Functions
    //--------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label1.text = "Login Please"
        playStopButton.isHidden = true
        
        // Do any additional setup after loading the view, typically from a nib.
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func setup () {
        // insert redirect your url and client ID below
        let redirectURL = "myshuffle://callback" // put your redirect URL here
        let clientID = "91eacb7a43c74feb8891e5afa6373377" // put your client ID here
        auth.redirectURL     = URL(string: redirectURL)
        auth.clientID        = clientID
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
        
    }
    
    @objc func initializaPlayer(authSession:SPTSession){
        if self.player == nil {
            
            
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player?.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
            
        }
        
    }
    
    @IBOutlet weak var label1: UILabel!
    
    @objc func updateAfterFirstLogin () {
        
        let userDefaults = UserDefaults.standard
        
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            playStopButton.isHidden = false
            
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            
            self.session = firstTimeSession
            initializaPlayer(authSession: session)
            self.loginButton.isHidden = true
            self.label1.text = "Play/Stop"
           // self.loadingLabel.isHidden = false
            
        } else {
            self.label1.text = "Login Failed!"
        }
        
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
       print("logged in")
            self.player?.playSpotifyURI("spotify:track:0TDLuuLlV54CkRRUOahJb4", startingWith: 0, startingWithPosition: 0, callback: { (error) in
                if (error != nil) {
                    print("playing!")
                }
                
            })
        
    }
    
    
    @IBAction func playStop(_ sender: Any) {
        if !self.playStopButton.isOn{
            self.player?.setIsPlaying(false, callback: nil)
        } else {
            self.player?.setIsPlaying(true, callback: nil)
        }
        
    }
    
    
    @IBOutlet weak var changeSong: UIButton!
    
    let arraysongs = ["5SxlUF7J8tyFIEF22EomeP","0TDLuuLlV54CkRRUOahJb4" ]
    var index = 0;
    
    @IBAction func change(_ sender: Any) {
        index = index + 1
        let value = index % arraysongs.count
        self.player?.playSpotifyURI("spotify:track:\(arraysongs[value])", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
            
        })
    }
    

    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
   //     UIApplication.shared.open(loginUrl!, options: nil, completionHandler: nil)
        
        if UIApplication.shared.openURL(loginUrl!) {
            
            if auth.canHandle(auth.redirectURL) {
                // To do - build in error handling
            }
        }
    }
    
    

}

