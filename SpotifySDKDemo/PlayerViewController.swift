//
//  PlayerViewController.swift
//  SpotifySDKDemo
//
//  Created by Carlos Quiles on 4/10/18.
//  Copyright © 2018 Elon Rubin. All rights reserved.
//

import UIKit
import Spartan

var referenceplayer : PlayerViewController? = nil
var lastID = ""
var dur = 0

class PlayerViewController: GenericViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {

    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var reloadButton: UIImageView!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var buttonVolume: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var coverbig: UIImageView!
    var isowner = false
    var party : Party? = nil
    
    /*override func viewWillDisappear(_ animated: Bool) {
        if let player = self.player{
            player.playbackDelegate = nil
            player.delegate = nil
            player.setIsPlaying(false, callback: nil)
            player.logout()
            try! player.stop()
        }
        self.player = nil
        
    }*/
    
    
    @IBAction func changePart(_ sender: Any) {
        self.player?.playSpotifyURI("spotify:track:\(lastID)", startingWith: 0, startingWithPosition: TimeInterval(slider.value/1000), callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
        if (self.buttonPlay.currentImage == #imageLiteral(resourceName: "Stop")){
            self.player?.setIsPlaying(false, callback: nil)
        }
        
    }
    
    
    @IBAction func playStop(_ sender: Any) {
        if let playback = self.player?.playbackState {
                if (playback.isPlaying){
                self.player?.setIsPlaying(false, callback: nil)
                buttonPlay.setImage(#imageLiteral(resourceName: "Stop"), for: .normal)
            } else {
                self.player?.setIsPlaying(true, callback: nil)
                buttonPlay.setImage(#imageLiteral(resourceName: "play_alt-512"), for: .normal)
            }
        }
    }
    
    
    var mysongs = [MusicPropierties]()
    
    
    func fillData(_ party: Party, reload: Bool){
        let songs = Song.returnSongs(party: party)
        let URIformat = songs.map{$0.id}
        
        _ = Spartan.getTracks(ids: URIformat, market: .us, success: { (tracks) in
            sortedsongs?.songs.removeAll()
            self.mysongs.removeAll()
            var prov = [MusicPropierties]()
            for i in 0..<tracks.count {
                let item = tracks[i]
                let url = URL(string: item.album.images[1].url)
                let image = UIImage(data: (NSData(contentsOf: url!)! as Data))
                let votes = Song.getVotes(idparty: party.id, idsong: songs[i].id)
                let duration = item.durationMs
                let name = item.name + " " + item.artists[0].name
                let newcell = MusicPropierties(photo: image!, name: name, id: songs[i].id, votes: votes, duration: duration!,played: songs[i].played)
                
                    prov += [newcell]
            }
            
            prov.sort{$0.votes < $1.votes}
            
            prov.sort(by: { (a, b) -> Bool in
                if (a.played && !b.played){
                    return true
                }
                else if (!a.played && b.played){
                    return false
                }
                else {
                    return true
                }
            })
            
            sortedsongs?.songs = prov
            self.mysongs = prov
            
            if let bool = self.player?.playbackState {
                self.slider.setValue(Float(bool.position*1000), animated: true)
                let song = self.mysongs.index{$0.id == lastID}
                self.slider.maximumValue = Float(dur)
                self.coverbig.image = self.mysongs[song!].photo
                self.song.text = self.mysongs[song!].name
            }
            
            
            if (reload){
                self.reloadValues()
            }
            sortedsongs?.tableView.reloadData()
        }, failure: { (error) in
            print(error)
        })
    }
    
    @objc var player: SPTAudioStreamingController?
    
    
    public func changesong(id: String, duration: Int) {
        if (lastID == id){
            return
        }
        lastID = id
        dur = duration
        self.player?.playSpotifyURI("spotify:track:\(id)", startingWith: 0, startingWithPosition: 0.0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
            
        })
        Party.setPlayingSong(party: party!, song: id)
        self.player?.setIsPlaying(false, callback: nil)
        self.slider.maximumValue = Float(duration)
        self.slider.setValue(0.0, animated: true)
    }
    
    @objc func initializaPlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player?.delegate = self
        }
    }
    
    func reloadValues(){
        var index = mysongs.index { $0.id == lastID}
        repeat{
            index! += 1
        } while index!<mysongs.count && mysongs[index!].played
        if mysongs.count > index!{
            changesong(id: mysongs[index!].id, duration: mysongs[index!].duration)
            player?.setIsPlaying(true, callback: nil)
            self.coverbig.image = mysongs[index!].photo
            self.song.text = mysongs[index!].name
        }
        else{
            self.player?.setIsPlaying(false, callback: nil)
            slider.value = 0
        }
    }
    
    @objc func timerFired(_ : Any) {
        if self.player != nil {
            if let playback = player?.playbackState{
                    slider.setValue(Float(playback.position*1000), animated: true)
            }
            
        }
        if (slider.maximumValue - slider.value < 1000){
            Song.played(song: lastID, party: (party?.id)!)
            fillData(party!,reload: true)
            
        }
    }
    
    @objc func checkNew(_ : Any) {
        fillData(party!, reload: false)
        if let newsong = Party.getPlayingSong(party: party!, songs: mysongs) {
            self.coverbig.image = newsong.photo
            self.song.text = newsong.name
        }
    }
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.value = 0
        slider.maximumValue = 100000000
        referenceplayer = self
        if let par = party{
            info.text = par.name
            fillData(par, reload: false)
            isowner = (par.creator == session?.canonicalUsername)
            if (isowner) {
                info.text?.append(" by yourself")
                initializaPlayer(authSession: session!)
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerFired(_:)), userInfo: nil, repeats: true)
                
            }
            else{
                reloadButton.isHidden = true
                info.text?.append(" by \(par.creator)")
                buttonPlay.isHidden = true
                buttonVolume.isHidden = true
                slider.isHidden = true
                self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.checkNew(_:)), userInfo: nil, repeats: true)
            }
            
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   func backtoList(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "TabBar")
        present(vc!, animated: true, completion: nil)
    }
    
    func delete() {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this party?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            Party.dropeParty(party: self.party!)
            self.backtoList()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func removereference(){
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to exit from this party?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            Party.unsubscribeParty(party: self.party!, user: (session?.canonicalUsername)!)
            self.backtoList()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBAction func deleteList(_ sender: Any) {
        if (isowner){
            delete()
        }
        else{
            removereference()
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
