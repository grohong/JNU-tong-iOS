//
//  CityBusDetailViewController.swift
//  JUN-tong
//
//  Created by Seong ho Hong on 2017. 9. 30..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import UIKit

class CityBusDetailViewController: UIViewController {
    
    @IBOutlet weak var busNoLabel: UILabel!
    @IBOutlet weak var busLineLabel: UILabel!
    @IBOutlet weak var busImageView: UIView!

    @IBOutlet weak var busTimeClickStatus: UIView!
    @IBOutlet weak var busLineClickStatus: UIView!
    
    @IBOutlet weak var busColorView: UIView!
    @IBOutlet weak var busLineView: UIView!
    @IBOutlet weak var busTimeView: UIView!
    
    var busInfo: CityBus?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        busColorView.backgroundColor = busInfo?.cityBusColor
        busImageView.layer.borderColor = busInfo?.cityBusColor.cgColor
        busImageView.layer.borderWidth = 3
        busImageView.layer.cornerRadius = 36
        
        busTimeClickStatus.layer.backgroundColor = UIColor.white.cgColor
        
        busLineView.alpha = 1
        busTimeView.alpha = 0
        
        busNoLabel.textColor = busInfo?.cityBusColor
        busNoLabel.text = busInfo!.lineNo
        busLineLabel.textColor = busInfo?.cityBusColor
        busLineLabel.text = busInfo!.description
    }
    
    @IBAction func timeTableButton(_ sender: Any) {
        busLineClickStatus.layer.backgroundColor = UIColor.white.cgColor
        busTimeClickStatus.layer.backgroundColor = UIColor.darkGray.cgColor
        
        UIView.animate(withDuration: 0.5, animations: {
            self.busLineView.alpha = 0
            self.busTimeView.alpha = 1
        })
    }
    
    @IBAction func busLineButton(_ sender: Any) {
        busTimeClickStatus.layer.backgroundColor = UIColor.white.cgColor
        busLineClickStatus.layer.backgroundColor = UIColor.darkGray.cgColor
        
        UIView.animate(withDuration: 0.5, animations: {
            self.busLineView.alpha = 1
            self.busTimeView.alpha = 0
        })
    }
}