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
import Spartan

let redirectUrl = "myshuffle://callback" // put your redirect URL here
let clientID = "91eacb7a43c74feb8891e5afa6373377" // put your client ID here

var referencemain : MainViewController? = nil

var session : SPTSession? = nil

class MainViewController: GenericViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {

    //--------------------------------------
    // MARK: Variables
    //--------------------------------------
    
    // Variables
    @objc var auth = SPTAuth.defaultInstance()!
    //@objc var session:SPTSession!
    
    // Initialzed in either updateAfterFirstLogin: (if first time login) or in viewDidLoad (when there is a check for a session object in User Defaults
    @objc var player: SPTAudioStreamingController?
    @objc var loginUrl: URL?
    
    
    //--------------------------------------
    // MARK: Outlets
    //--------------------------------------
    
    @IBOutlet weak var loginButton: UIButton!
    
    //--------------------------------------
    // MARK: Functions
    //--------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        referencemain = self
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "login"), object: nil)
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    @objc func updateAfterFirstLogin(){
        let userDefaults = UserDefaults.standard
        
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            
            session = firstTimeSession
            Spartan.authorizationToken = firstTimeSession.accessToken
            performSegue(withIdentifier: "normalsegue", sender: nil)
            
                if self.player == nil {
                    self.player = SPTAudioStreamingController.sharedInstance()
                    self.player!.playbackDelegate = self
                    self.player!.delegate = self
                    try! player?.start(withClientId: clientID)
                    self.player!.login(withAccessToken: firstTimeSession.accessToken)
                }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func setup () {
        // insert redirect your url and client ID below
        auth.redirectURL     = URL(string: redirectUrl)
        auth.clientID        = clientID
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
        
    }
    
    
    @IBOutlet weak var label1: UILabel!
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        //referencef?.auth = self.auth
   //     UIApplication.shared.open(loginUrl!, options: nil, completionHandler: nil)
        if UIApplication.shared.openURL(loginUrl!) {
            
            if auth.canHandle(auth.redirectURL) {
                let one = 1
                // To do - build in error handling
            }
        }
    }
}

