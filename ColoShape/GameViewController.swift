//
//  GameViewController.swift
//  ColoShape
//
//  Created by Davis Zarins on 21/10/2020.
//

import UIKit
import GameKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
        
        if defaults.bool(forKey: "GameCenter") {
            authenticateUser()
            GKAccessPoint.shared.location = .topTrailing
            GKAccessPoint.shared.isActive = true
        } else {
            GKAccessPoint.shared.isActive = false
        }
        
        // Score may have been reset in settings, so we set highScoreLabel in viewWillAppear
        switch difficultySegmentedControl.selectedSegmentIndex {
        case 0:
            highScoreLabel.text = "High Score: \(defaults.integer(forKey: "EasyHS"))"
        case 1:
            highScoreLabel.text = "High Score: \(defaults.integer(forKey: "MediumHS"))"
        default:
            highScoreLabel.text = "High Score: \(defaults.integer(forKey: "HardHS"))"
        }
        
    }
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let firstOpen = defaults.object(forKey: "FirstOpen") as? Date {
            // This is NOT the first launch
            print("The app was first opened on \(firstOpen)")
            difficultySegmentedControl.selectedSegmentIndex = defaults.integer(forKey: "Difficulty")
        } else {
            // This is the first launch
            defaults.set(difficultySegmentedControl.selectedSegmentIndex, forKey: "Difficulty")
            defaults.set(Date(), forKey: "FirstOpen")
            defaults.set(true, forKey: "Sound")
            defaults.set(true, forKey: "Vibration")
            defaults.set(true, forKey: "GameCenter")
            defaults.set(0, forKey: "EasyHS")
            defaults.set(0, forKey: "MediumHS")
            defaults.set(0, forKey: "HardHS")
        }
        
        //modify segmentedControl font, color
        let font = UIFont(name: "Comfortaa-Regular", size: 15)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                              NSAttributedString.Key.font: font!]
            difficultySegmentedControl.setTitleTextAttributes(textAttributes, for: .normal)
            difficultySegmentedControl.setTitleTextAttributes(textAttributes, for: .selected)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(playButtonPressed))
        playButton.addGestureRecognizer(tap)
        
        launchGameScene(testMode: true, difficulty: difficultySegmentedControl.selectedSegmentIndex)

    }
    
    //MARK: Game Center
    private func authenticateUser() {
        let player = GKLocalPlayer.local
        player.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            if let vc = vc {
                self.present(vc, animated: true, completion: nil)
                
            }
        }

    }
    
    //MARK: launchGameScene()
    func launchGameScene(testMode: Bool, difficulty: Int) {
        let scene = GameScene(size: view.bounds.size)
        scene.difficulty = difficulty
        scene.testMode = testMode
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
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
        default:
            highScoreLabel.text = "High Score: \(defaults.integer(forKey: "HardHS"))"
            launchGameScene(testMode: true, difficulty: 2)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
      return false
    }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
      return UIRectEdge.bottom
    }
    
    //MARK: playButtonPressed()
    @objc func playButtonPressed(sender: UITapGestureRecognizer? = nil) {
        GKAccessPoint.shared.isActive = false
        menuTitleLabel.removeFromSuperview()
        playButton.removeFromSuperview()
        difficultySegmentedControl.removeFromSuperview()
        settingsButton.removeFromSuperview()
        highScoreLabel.removeFromSuperview()
        defaults.set(difficultySegmentedControl.selectedSegmentIndex, forKey: "Difficulty")
        backgroundImageView.removeFromSuperview()
        launchGameScene(testMode: false, difficulty: defaults.integer(forKey: "Difficulty"))
    }
    
}

extension GameViewController: GKGameCenterControllerDelegate {

  func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    gameCenterViewController.dismiss(animated: true, completion: nil)
  }

}
