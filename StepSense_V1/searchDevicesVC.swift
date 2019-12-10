//
//  searchDevicesVC.swift
//  StepSense_V1
//
//  Created by Ajit Ravisaravanan on 11/9/19.
//  Copyright © 2019 Ajit Ravisaravanan. All rights reserved.
//

import UIKit
import Firebase

class searchDevicesVC: UIViewController{
    
    let db = Firestore.firestore()
    
    var devices_list = ["dev1", "dev2", "dev3"]

    @IBOutlet weak var resultsButton: UIButton!
    
    @IBOutlet var searchDevicesButton: UIButton!
    @IBOutlet weak var devicesTableView: UITableView!
    
    @IBAction func searchDevicesButton(_ sender: Any) {
        showList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //devicesTableView.delegate = self
        //devicesTableView.dataSource = self
        devicesTableView.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    func showList(){
        devicesTableView.isHidden = false
    }
    
    func hideList(){
        devicesTableView.isHidden = true
        searchDevicesButton.isHidden = true
    }
    
}
