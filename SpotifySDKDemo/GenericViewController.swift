//
//  GenericViewController.swift
//  SpotifySDKDemo
//
//  Created by Jose Carlos Torres Quiles on 3/29/18.
//  Copyright © 2018 Elon Rubin. All rights reserved.
//

import UIKit

var referencesongcontroller : GenericViewController? = nil

class GenericViewController: UIViewController {
    let gradient = CAGradientLayer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor(rgb: 0x99ccff).cgColor, UIColor(rgb: 0x9999ff).cgColor]
        gradient.locations = [0.25, 0.75]
        self.view.layer.insertSublayer(gradient, at: 0)
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

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

