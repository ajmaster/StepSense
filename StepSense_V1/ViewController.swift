//
//  ViewController.swift
//  StepSense_V1
//
//  Created by Ajit Ravisaravanan on 11/9/19.
//  Copyright © 2019 Ajit Ravisaravanan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLogo: UIImageView!
    @IBOutlet weak var goButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    func setupUI(){
        titleLogo.image = #imageLiteral(resourceName: "19-194164_footsteps-clipart-foot-step-marauders-map-footprints-png")
        goButton.layer.cornerRadius = 2
        goButton.layer.borderColor = UIColor.black.cgColor
        goButton.layer.borderWidth = 1
    }

}

