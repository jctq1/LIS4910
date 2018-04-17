//
//  Song.swift
//  SpotifySDKDemo
//
//  Created by Carlos Quiles on 4/10/18.
//  Copyright © 2018 Elon Rubin. All rights reserved.
//

import Foundation

class Song {
    let id : String
    let party : String
    let played : Bool
    
    init(id: String, party: String, played : Bool) {
        self.id = id
        self.party = party
        self.played = played
    }
    
    class func parseSongs(res: ResQuery) -> [Song] {
        var ret = [Song]()
        if let test = res.first{
            if (test["error"] != nil){
                return ret
            }
        }
        
        for row in res {
            let id = row["song"] as! String
            let party = row["party"] as! String
            let played = row["played"] as! String
            var check : Bool = false
            if (played == "1"){
                check = true
            }
            ret += [Song(id: id, party: party, played: check)]
        }
        
        return ret
    }
    
    class func returnSongs(party: Party) -> [Song] {
        let query = "SELECT song,party,played FROM songs WHERE party='\(party.id)' GROUP BY (song) ORDER BY vote DESC;"
        let res = SQLInteract.ExecuteSelect(query: query)
        return parseSongs(res: res.0)
    }
    
    class func returnSongsPlayed(party: Party) -> [Song] {
        let query = "SELECT DISTINCT song,party FROM songs WHERE party='\(party.id)' ORDER BY vote DESC WHERE played=1;"
        let res = SQLInteract.ExecuteSelect(query: query)
        return parseSongs(res: res.0)
    }
    
    class func played(song: String, party: String) -> StatusMsg {
        let query = "UPDATE songs SET played=1 WHERE party='\(party)' AND song='\(song)';"
        let res = SQLInteract.ExecuteModification(query: query)
        return res
    }
    
    class func parseVotes(res: ResQuery) -> Int {
        var ret = 0
        for row in res {
            let vote = row["vote"] as! String
            if (vote == "1"){
                ret += 1
            }
            else {
                ret -= 1
            }
        }
        
        return ret
    }
    
    
    class func getVotes(idparty: String, idsong: String) -> Int {
        let query = "SELECT vote FROM songs WHERE party='\(idparty)' AND song='\(idsong)';"
        let res = SQLInteract.ExecuteSelect(query: query)
        return parseVotes(res: res.0)
    }
    
    class func itVoted(songid: String, partyid: String, id: String) -> Int {
        let query = "SELECT vote FROM songs WHERE party='\(partyid)' AND song='\(songid)' AND account='\(id)';"
        let res = SQLInteract.ExecuteSelect(query: query)
        if (res.0.count == 0){
            return -1
        }
        else {
            let vote = res.0.first!["vote"] as! String
            if (vote == "1"){
                return 1
            }
            else {
                return 0
            }
        }
    }
    
    class func isOnParty(id: String, party: Party) -> Bool {
        let query = "SELECT * FROM songs WHERE party='\(party.id)' AND song='\(id)';"
        let res = SQLInteract.ExecuteSelect(query: query)
        if (res.0.count == 0){
            return false
        }
        return true
    }
    
    class func vote(song: String, party: String, userid: String, vote: Int) -> StatusMsg {
        let query = "DELETE FROM songs WHERE party='\(party)' AND song='\(song)' AND account='\(userid)';"
        let query2 = "INSERT INTO songs (party,song,account,vote) VALUES('\(party)','\(song)','\(userid)',\(vote));"
        let res = SQLInteract.ExecuteModification(query: query)
        let res2 = SQLInteract.ExecuteModification(query: query2)
        return res2
    }
}
