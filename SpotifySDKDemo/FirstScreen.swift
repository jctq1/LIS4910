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


class MusicCell: UITableViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var playStopButton: UIButton!
    var id: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)
    }
    
    @objc func tapAction() {
        referencemusic?.playStopInt(newID: id)
    }
}

class MusicPropierties {
    let name : String
    let photo : UIImage
    let id : String
    let votes : Int
    let duration : Int
    var played = false
    init(photo: UIImage, name: String, id: String, votes: Int, duration: Int, played: Bool) {
        self.name = name
        self.photo = photo
        self.id = id
        self.votes = votes
        self.duration = duration
        self.played = played
    }
}

var referencemusic : MusicTable? = nil

class MusicTable: UITableViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    public var songs = [MusicPropierties]()
    let cellIdentifier = "MusicCell"
    var lastID = ""
    
    public func playStopInt(newID : String) {
        if (newID != lastID) {
            self.changesong(id: newID)
            self.player?.setIsPlaying(true, callback: nil)
        } else {
            if (self.player?.playbackState.isPlaying)! {
                self.player?.setIsPlaying(false, callback: nil)
            } else {
                self.player?.setIsPlaying(true, callback: nil)
            }
        }
    }
    
    @IBAction func playStop(_ sender: Any) {
        let bla = self.tableView.indexPathForSelectedRow
        let currentCell = self.tableView.cellForRow(at: bla!) as! MusicCell
        let newID = currentCell.id
        playStopInt(newID: newID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.register(MusicCell.self, forCellReuseIdentifier: cellIdentifier)
        referencemusic = self
        clientID = (referencef?.auth.clientID)!
        songs += referencef!.table
        initializaPlayer(authSession: (referencef?.session)!)
    }
    
    var clientID : String = ""
    @objc var player: SPTAudioStreamingController?
    
    @objc func initializaPlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player?.start(withClientId: clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MusicCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let song = songs[indexPath.row]
        cell.name.text = song.name
        cell.photo.image = song.photo
        cell.id = song.id
        cell.playStopButton.accessibilityLabel = String(describing: indexPath.row)
        
        return cell
    }
    
    func changesong(id: String) {
        self.player?.playSpotifyURI("spotify:track:\(id)", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
            
        })
        self.player?.setIsPlaying(false, callback: nil)
    }
    
}

var referencef : FirstScreen? = nil

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
    
    @IBAction func changeSong(_ sender: Any) {
    }
    
    @objc func updateAfterFirstLogin(){
        let userDefaults = UserDefaults.standard
        
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            //initializaPlayer(authSession: self.session)
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
        referencef = self
        self.auth = (referencemain?.auth)!
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
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
    
    var table = [MusicPropierties]()
    
    /*@IBAction func searchSong(_ sender: Any) {
        let text = songname.text!
        
        let querytipe = SPTSearchQueryType.queryTypeTrack
        SPTSearch.perform(withQuery: text, queryType: querytipe, accessToken: session.accessToken) { (error, result) in
            if (result != nil){
                let results = result as! SPTListPage
                let items = results.tracksForPlayback()
                let casteditems = items! as! [SPTPartialTrack]
                for item in casteditems {
                    let url = (item.album.covers as! [SPTImage])[1].imageURL
                    let image = UIImage(data: NSData(contentsOf: url!)! as Data)
                    let newcell = MusicPropierties(photo: image!, name: item.name, id: item.identifier, votes: 0)
                    self.table += [newcell]
                }
                //let firstitem = casteditems[0].identifier
                //self.changesong(id: firstitem!)
               // self.songlist.dataSource = casteditems
                //self.song.text = casteditems[0].name
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc : UITableViewController = self.storyboard?.instantiateViewController(withIdentifier: "MusicTable") as! UITableViewController
                self.present(vc, animated: true, completion: nil)
                print(casteditems[0].sharingURL!)
                
            }
            else {
                print(error.debugDescription)
            }
            //table.tableView.reloadData()
        }
    }*/
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
