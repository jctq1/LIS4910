//
//  Presentation.swift
//  SpotifySDKDemo
//
//  Created by Jose Carlos Torres Quiles on 3/29/18.
//  Copyright © 2018 Elon Rubin. All rights reserved.
//

import UIKit

class TextCell : UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var party: UILabel!
}

class TableTextController : UITableViewController {
    
    let cellIdentifier = "textcell"
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? TextCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        cell.title.text = "New 24 songs have been added!"
        cell.party.text = "Spring Party"
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.register(MusicCell.self, forCellReuseIdentifier: cellIdentifier)
    }
}

class Presentation: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
