//
//  CreatedViewController.swift
//  SpotifySDKDemo
//
//  Created by Carlos Quiles on 4/10/18.
//  Copyright © 2018 Elon Rubin. All rights reserved.
//

import UIKit

class CreatedViewController: GenericViewController {
    @IBOutlet weak var createfield: UITextField!
    
    @IBAction func createparty(_ sender: Any) {
        let id = session?.canonicalUsername
        let text = createfield.text!
        _ = Party.createParty(name: text, creator: id!)
        let parties = Party.returnOwnedParties(id: id!)
        referencepartytable?.parties = parties
        referencepartytable?.tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let id = session?.canonicalUsername
        let parties = Party.returnOwnedParties(id: id!)
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
