//
//  GameViewController.swift
//  ColoShape
//
//  Created by Davis Zarins on 21/10/2020.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!
    @IBOutlet weak var settingsButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(playButtonPressed))
        playButton.addGestureRecognizer(tap)
        
        difficultySegmentedControl.selectedSegmentIndex = defaults.integer(forKey: "Difficulty")
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    @objc func playButtonPressed(sender: UITapGestureRecognizer? = nil) {
        menuTitle.removeFromSuperview()
        playButton.removeFromSuperview()
        difficultySegmentedControl.removeFromSuperview()
        settingsButton.removeFromSuperview()
        defaults.set(difficultySegmentedControl.selectedSegmentIndex, forKey: "Difficulty")
        
        let scene = GameScene(size: view.bounds.size)
        scene.difficulty = difficultySegmentedControl.selectedSegmentIndex
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
}
