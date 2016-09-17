//
//  HowToPlayViewController.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 17/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class HowToPlayViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gotItButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var dialogView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func gotItButtonClicked(_ sender: UIButton) {
        let _ = navigationController?.popViewController(animated: true)
    }

}
