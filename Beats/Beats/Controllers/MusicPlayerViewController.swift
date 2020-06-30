//
//  MusicPlayerViewController.swift
//  Beats
//
//  Created by Nirav Adunuthula on 6/26/20.
//  Copyright © 2020 Nirav Adunuthula. All rights reserved.
//

import UIKit
import CoreLocation

class MusicPlayerViewController: UIViewController {
    // MARK: - Properties
    
    //Music
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    
    @IBOutlet weak var heart: UIImageView!
    @IBOutlet weak var pause_and_play: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var pauseSongButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    
    //Activity Stats
    @IBOutlet weak var timeElapsed: UILabel!
    @IBOutlet weak var pace: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var bpm: UILabel!
    
    @IBOutlet weak var paceUpIm: UIImageView!
    @IBOutlet weak var paceDownIm: UIImageView!
    @IBOutlet weak var paceUp: UIButton!
    @IBOutlet weak var paceDown: UIButton!
    
    //Pause or End Activity
    @IBOutlet weak var pauseActivity: UIButton!
    @IBOutlet weak var endActivity: UIButton!
    
    //MARK: - Spotify Remote
    var appRemote: SPTAppRemote? {
        get {
            return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.appRemote
        }
    }
    
    //MARK: - CLLocation Manager
    var locationManager: CLLocationManager? {
        get {
            return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.locationManager
        }
    }
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - IBActions
    
    //Music
    @IBAction func skipButtonTouched(_ sender: Any) {
    }
    @IBAction func pauseButtonTouched(_ sender: Any) {
    }
    @IBAction func likeButtonTouched(_ sender: Any) {
    }
    
    //Adjust Pace
    @IBAction func paceUpTouched(_ sender: Any) {
    }
    @IBAction func paceDownTouched(_ sender: Any) {
    }
    
    //Pause or End Activity
    @IBAction func pauseActivityTouched(_ sender: Any) {
    }
    @IBAction func endActivityTouched(_ sender: Any) {
    }
}
