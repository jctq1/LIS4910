//
//  Party.swift
//  SpotifySDKDemo
//
//  Created by Carlos Quiles on 4/10/18.
//  Copyright © 2018 Elon Rubin. All rights reserved.
//

import Foundation

class Party {
    let id: String
    let name: String
    let creator: String
    
    init(id: String, name: String, creator: String) {
        self.id = id
        self.name = name
        self.creator = creator
    }
    
    class func parseParty (res: ResQuery) -> [Party] {
        var parties = [Party]()
        for row in res {
            let id = row["id"] as! String
            let name = row["name"] as! String
            let creator = row["creator"] as! String
            parties += [Party(id: id, name: name, creator: creator)]
        }
        
        return parties
    }
    
    class func returnOwnedParties (id: String) -> [Party] {
        let query = "SELECT id,name,creator FROM party WHERE creator='\(id)';"
        let res = SQLInteract.ExecuteSelect(query: query)
        return parseParty(res: res.0)
    }
    
    class func returnSubscribedParties (id: String) -> [Party] {
        let query = "SELECT id,name,creator FROM party WHERE subscribed LIKE '%\(id)%';"
        let res = SQLInteract.ExecuteSelect(query: query)
        return parseParty(res: res.0)
    }
    
    class func checkID(id: String) -> Bool {
        let query = "SELECT * FROM party WHERE id='\(id)';"
        let res = SQLInteract.ExecuteSelect(query: query)
        return (res.0.count != 0)
    }
    
    class func createParty (name: String, creator: String) -> StatusMsg {
        var id = ""
        repeat {
            id = String.random()
        } while checkID(id: id)
        
        let par = Party(id: id, name: name, creator: creator)
        return uploadParty(party: par)
    }
    
    class func uploadParty (party: Party) -> StatusMsg {
        let query = "INSERT INTO party VALUES('\(party.name)','\(party.creator)','\(party.id)','');"
        let res = SQLInteract.ExecuteModification(query: query)
        return res
    }
    
    class func getsubs (id: String) -> String? {
        let query = "SELECT subscribed FROM party WHERE id='\(id)';"
        let res = SQLInteract.ExecuteSelect(query: query)
        if (res.0.count == 0){
            return nil
        }
        else {
            return (res.0.first!["subscribed"] as! String)
        }
    }
    
    /* Remove a course from a Tutor */
    class func removeSub (list: String, user: String) -> String {
        let splitlist = list.split(separator: ",").map{ String($0)}
        let mutatedlist = splitlist.filter{$0 != user}
        return mutatedlist.joined(separator: ",")
    }
    
    class func subscribeParty (id: String, user: String) -> StatusMsg {
        if let string = getsubs(id: id){
            if string.range(of:user) != nil {
                return (false, "You can't subscribe to your own games")
            }
            var stringf : String = string
            stringf.append(",\(user)")
            let query = "UPDATE party SET subscribed='\(stringf) WHERE id='\(id)';"
            let res = SQLInteract.ExecuteModification(query: query)
            return res
        }
        else {
            return (false, "There's no such party :(")
        }
    }
    
    class func unsubscribeParty (party: Party, user: String) -> StatusMsg {
        let string = getsubs(id: party.id)
        if let res = string {
            let stringf = removeSub(list: res, user: user)
            let query = "UPDATE party SET subscribed='\(stringf) WHERE id='\(party.id)';"
            let res = SQLInteract.ExecuteModification(query: query)
            return res
        }
        else {
            return (false, "There's no such party :(")
        }
    }
    
    class func dropeParty (party: Party) -> StatusMsg {
        let query = "DELETE FROM party WHERE id='\(party.id)';"
        let res = SQLInteract.ExecuteModification(query: query)
        return res
    }
    
}


extension String {
    
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
