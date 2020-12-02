//
//  SettingsViewController.swift
//  ColoShape
//
//  Created by Davis Zarins on 27/11/2020.
//

import UIKit

class SettingsViewController: UITableViewController {
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var vibrationSwitch: UISwitch!
    let defaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //removes unnecesary cells after last section
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        
        soundSwitch.isOn = defaults.bool(forKey: "Sound")
        vibrationSwitch.isOn = defaults.bool(forKey: "Vibration")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        defaults.set(soundSwitch.isOn, forKey: "Sound")
        defaults.set(vibrationSwitch.isOn, forKey: "Vibration")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
