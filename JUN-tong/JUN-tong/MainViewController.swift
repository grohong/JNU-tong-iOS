//
//  MainViewController.swift
//  JUN-tong
//
//  Created by Seong ho Hong on 2017. 9. 16..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var cityBusMain: UIView!
    @IBOutlet weak var shuttleBusMain: UIView!
    
    @IBOutlet weak var cityBusInfo: UIView!
    @IBOutlet weak var cityBusTable: UITableView!
    
    @IBOutlet weak var cityBusTableHeight: NSLayoutConstraint!
    
    var mainView = true
    // 본래 있던 자리를 알기 위해
    var shuttleBusCenter: CGPoint?
    var extensRange: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cityBusInfoTap = UITapGestureRecognizer(target: self, action: #selector(self.cityBusInfoTap(_:)))
        cityBusInfoTap.delegate = self
        cityBusInfo.addGestureRecognizer(cityBusInfoTap)
        
        shuttleBusCenter = shuttleBusMain.center
        extensRange = self.view.bounds.height-25-180
        
        cityBusMain.layer.borderColor = UIColor.darkGray.cgColor
        cityBusMain.layer.borderWidth = 0.5
        cityBusMain.layer.cornerRadius = 7
        
        shuttleBusMain.layer.borderColor = UIColor.darkGray.cgColor
        shuttleBusMain.layer.borderWidth = 0.5
        shuttleBusMain.layer.cornerRadius = 7
        
        self.cityBusTable.delegate = self
        self.cityBusTable.dataSource = self
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

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        if section == 0{
            let headerText = UILabel()
            headerText.text = "자주타는 버스"
            headerText.textColor = UIColor.init(red: CGFloat(0.0 / 255.0), green: CGFloat(44.0 / 255.0), blue: CGFloat(65.0 / 255.0), alpha: 1)
            headerText.frame = CGRect(x: 15, y: 10, width: 100, height: 25)
            headerText.font = UIFont.boldSystemFont(ofSize: 14)
            headerView.addSubview(headerText)
            headerView.layer.backgroundColor = UIColor.init(red: CGFloat(238.0 / 255.0), green: CGFloat(238.0 / 255.0), blue: CGFloat(238.0 / 255.0), alpha: 1).cgColor
            return headerView
        } else {
            let headerText = UILabel()
            headerText.text = "도착예정 버스"
            headerText.textColor = UIColor.init(red: CGFloat(0.0 / 255.0), green: CGFloat(44.0 / 255.0), blue: CGFloat(65.0 / 255.0), alpha: 1)
            headerText.frame = CGRect(x: 15, y: 10, width: 100, height: 25)
            headerText.font = UIFont.boldSystemFont(ofSize: 14)
            headerView.addSubview(headerText)
            headerView.layer.backgroundColor = UIColor.init(red: CGFloat(238.0 / 255.0), green: CGFloat(238.0 / 255.0), blue: CGFloat(238.0 / 255.0), alpha: 1).cgColor
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cityBusCell", for: indexPath) as? CityBusCell {
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    func cityBusInfoTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
        if mainView == true {
            self.mainView = false
        
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.cityBusMain.frame.size.height += self.view.bounds.height-25-180
                self.cityBusTableHeight.constant += self.view.bounds.height-25-180
                self.cityBusTable.frame.size.height += self.view.bounds.height-25-180
                self.shuttleBusMain.center = CGPoint(x: self.view.bounds.width/2, y: self.shuttleBusMain.frame.height + self.view.bounds.height)
            })
        } else if mainView == false {
            self.mainView = true
            
            UIView.animate(withDuration: 0.5, delay: 0, animations: {

                self.cityBusMain.frame.size.height -= self.view.bounds.height-25-180
                self.cityBusTableHeight.constant -= self.view.bounds.height-25-180
                self.cityBusTable.frame.size.height -= self.view.bounds.height-25-180
                self.shuttleBusMain.center = CGPoint(x: self.view.bounds.width/2, y: (self.shuttleBusCenter?.y)!)
            })
        }
    }
}
