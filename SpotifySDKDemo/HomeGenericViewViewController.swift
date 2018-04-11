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

class HomeGenericViewViewController: GenericViewController {
    @IBOutlet weak var username: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SPTUser.request(session!.canonicalUsername, withAccessToken: session?.accessToken, callback: { (error, result) in
            if let profile = result as? SPTUser {
                self.username.text = "Hey \(profile.canonicalUserName!)"
            } else {
                self.username.text = "Hey generic"
            }
        })
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
