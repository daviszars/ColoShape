//
//  GameViewController.swift
//  ColoShape
//
//  Created by Davis Zarins on 21/10/2020.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

class GameViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    private func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                // Tracking authorization completed. Start loading ads here.
                // loadAd()
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-5281174389456976/2976938976"
        //ca-app-pub-5281174389456976/2976938976 - real one
        //ca-app-pub-3940256099942544/2934735716 - test
        banner.load(GADRequest())
        //banner.backgroundColor = .secondarySystemBackground
        return banner
    }()
    
    private var interstitialAd: GADInterstitial?
    
    private func createAd() -> GADInterstitial {
        //ca-app-pub-5281174389456976/1104921278 - real one
        //ca-app-pub-3940256099942544/4411468910 - test
        let ad = GADInterstitial(adUnitID: "ca-app-pub-5281174389456976/1104921278")
        ad.delegate = self
        ad.load(GADRequest())
        return ad
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = CGRect(x: 0, y: view.safeAreaLayoutGuide.layoutFrame.maxY - 50, width: view.frame.size.width, height: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
    }
    
    let defaults = UserDefaults.standard
    let productID = "com.daviszarins.ColoShape.RemoveAds"
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestIDFA()
        if defaults.bool(forKey: productID) == false {
            banner.rootViewController = self
            view.addSubview(banner)
        }
        self.interstitialAd = createAd()
        
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
            defaults.set(0, forKey: "EasyHS")
            defaults.set(0, forKey: "MediumHS")
            defaults.set(0, forKey: "HardHS")
            defaults.set(false, forKey: productID)
        }
        
        if defaults.bool(forKey: productID) {
            print ("must not show ads")
        } else {
            print("must show ads")
        }
        
        //modify segmentedControl font, color
        let font = UIFont(name: "Comfortaa-Regular", size: 15)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                              NSAttributedString.Key.font: font!]
            difficultySegmentedControl.setTitleTextAttributes(textAttributes, for: .normal)
            difficultySegmentedControl.setTitleTextAttributes(textAttributes, for: .selected)
        
        
        switch difficultySegmentedControl.selectedSegmentIndex {
        case 0:
            highScoreLabel.text = "High Score: \(defaults.integer(forKey: "EasyHS"))"
        case 1:
            highScoreLabel.text = "High Score: \(defaults.integer(forKey: "MediumHS"))"
        default:
            highScoreLabel.text = "High Score: \(defaults.integer(forKey: "HardHS"))"
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(playButtonPressed))
        playButton.addGestureRecognizer(tap)
        
        launchGameScene(testMode: true, difficulty: difficultySegmentedControl.selectedSegmentIndex)

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
        //backgroundImageView.removeFromSuperview()
        menuTitleLabel.removeFromSuperview()
        playButton.removeFromSuperview()
        difficultySegmentedControl.removeFromSuperview()
        settingsButton.removeFromSuperview()
        highScoreLabel.removeFromSuperview()
        banner.removeFromSuperview()
        defaults.set(difficultySegmentedControl.selectedSegmentIndex, forKey: "Difficulty")
        let chance = 1...2
        if interstitialAd?.isReady == true && defaults.bool(forKey: productID) == false && chance.randomElement()! == 1 {
            backgroundImageView.alpha = 1
            interstitialAd?.present(fromRootViewController: self)
        } else {
            backgroundImageView.removeFromSuperview()
            launchGameScene(testMode: false, difficulty: defaults.integer(forKey: "Difficulty"))
        }
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        backgroundImageView.removeFromSuperview()
        launchGameScene(testMode: false, difficulty: defaults.integer(forKey: "Difficulty"))
    }
    
}

extension UIViewController: GADInterstitialDelegate {
//    public func interstitialDidDismissScreen(_ ad: GADInterstitial) {
//        interstitialAd = createAd()
//    }
}
