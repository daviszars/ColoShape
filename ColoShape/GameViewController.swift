//
//  GameViewController.swift
//  ColoShape
//
//  Created by Davis Zarins on 21/10/2020.
//
//
//  Roses are red,
//  Violets are blue
//  Unexpected '{'
//  on line 32

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
    }
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let firstOpen = defaults.object(forKey: "FirstOpen") as? Date {
            // This is NOT the first launch
            print("The app was first opened on \(firstOpen)")
            difficultySegmentedControl.selectedSegmentIndex = defaults.integer(forKey: "Difficulty")
            //remove later vvvvv
            defaults.set(0, forKey: "EasyHS")
            defaults.set(0, forKey: "MediumHS")
            defaults.set(0, forKey: "HardHS")
        } else {
            // This is the first launch
            defaults.set(difficultySegmentedControl.selectedSegmentIndex, forKey: "Difficulty")
            defaults.set(Date(), forKey: "FirstOpen")
            defaults.set(true, forKey: "Sound")
            defaults.set(true, forKey: "Vibration")
            defaults.set(0, forKey: "EasyHS")
            defaults.set(0, forKey: "MediumHS")
            defaults.set(0, forKey: "HardHS")
        }
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            difficultySegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
            difficultySegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        
        switch difficultySegmentedControl.selectedSegmentIndex {
        case 0:
            highScoreLabel.text = "High Score: \(defaults.integer(forKey: "EasyHS"))"
        case 1:
            highScoreLabel.text = "High Score: \(defaults.integer(forKey: "MediumHS"))"
        case 2:
            highScoreLabel.text = "High Score: \(defaults.integer(forKey: "HardHS"))"
        default:
            print("??")
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(playButtonPressed))
        playButton.addGestureRecognizer(tap)
        
        //        let scene = GameScene(size: view.bounds.size)
        //        scene.difficulty = difficultySegmentedControl.selectedSegmentIndex
        //        scene.testMode = true
        //        let skView = view as! SKView
        //        skView.showsFPS = true
        //        skView.showsNodeCount = true
        //        skView.ignoresSiblingOrder = true
        //        scene.scaleMode = .resizeFill
        //        skView.presentScene(scene)
        launchGameScene(testMode: true, difficulty: difficultySegmentedControl.selectedSegmentIndex)
    }
    
    func launchGameScene(testMode: Bool, difficulty: Int) {
        let scene = GameScene(size: view.bounds.size)
        scene.difficulty = difficulty
        scene.testMode = testMode
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    @IBAction func difficultySegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch difficultySegmentedControl.selectedSegmentIndex {
        case 0:
            highScoreLabel.text = "High Score: \(defaults.integer(forKey: "EasyHS"))"
            launchGameScene(testMode: true, difficulty: 0)
        case 1:
            highScoreLabel.text = "High Score: \(defaults.integer(forKey: "MediumHS"))"
            launchGameScene(testMode: true, difficulty: 1)
        case 2:
            highScoreLabel.text = "High Score: \(defaults.integer(forKey: "HardHS"))"
            launchGameScene(testMode: true, difficulty: 2)
        default:
            print("??")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    @objc func playButtonPressed(sender: UITapGestureRecognizer? = nil) {
        backgroundImageView.removeFromSuperview()
        menuTitleLabel.removeFromSuperview()
        playButton.removeFromSuperview()
        difficultySegmentedControl.removeFromSuperview()
        settingsButton.removeFromSuperview()
        highScoreLabel.removeFromSuperview()
        defaults.set(difficultySegmentedControl.selectedSegmentIndex, forKey: "Difficulty")
        
        //        let scene = GameScene(size: view.bounds.size)
        //        scene.difficulty = difficultySegmentedControl.selectedSegmentIndex
        //        let skView = view as! SKView
        //        skView.showsFPS = true
        //        skView.showsNodeCount = true
        //        skView.ignoresSiblingOrder = true
        //        scene.scaleMode = .resizeFill
        //        skView.presentScene(scene)
        launchGameScene(testMode: false, difficulty: difficultySegmentedControl.selectedSegmentIndex)
    }
    
}
