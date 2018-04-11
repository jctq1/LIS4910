//
//  SubscribedViewController.swift
//  SpotifySDKDemo
//
//  Created by Carlos Quiles on 4/10/18.
//  Copyright © 2018 Elon Rubin. All rights reserved.
//

import UIKit

class SubscribedViewController: GenericViewController {

    @IBOutlet weak var partyid: UITextField!
    @IBAction func addparty(_ sender: Any) {
        let id = session?.canonicalUsername
        let text = partyid.text!
        _ = Party.subscribeParty(id: text, user: id!)
        let parties = Party.returnSubscribedParties(id: id!)
        referencepartytable?.parties = parties
        referencepartytable?.tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let id = session?.canonicalUsername
        let parties = Party.returnSubscribedParties(id: id!)
        referencepartytable?.parties = parties
        referencepartytable?.tableView.reloadData()
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
