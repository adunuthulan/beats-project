//
//  SceneDelegate.swift
//  Beats
//
//  Created by Nirav Adunuthula on 6/9/20.
//  Copyright © 2020 Nirav Adunuthula. All rights reserved.
//

import UIKit
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate,
 SPTAppRemoteDelegate, SPTSessionManagerDelegate, CLLocationManagerDelegate
{

    var window: UIWindow?

    //Spotify App Config
    private let SpotifyClientID = "e82364b32b39478fb2dd2babf9dcb3ff"
    private let SpotifyRedirectURI = URL(string: "spotify-ios-quick-start://spotify-login-callback")!

    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
        configuration.playURI = "spotify:track:2bNCdW4rLnCTzgqUXTTDO1"

        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "https://reveriebeats.herokuapp.com/api/token")
        configuration.tokenRefreshURL = URL(string: "https://reveriebeats.herokuapp.com/api/refresh_token")
        return configuration
    }()
    
    //Manages Token Swap with Heroku app
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()

    //Object used to interact with Spotify Player
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    //stores the view controller with the remote player in it
    var playerViewController: ViewController {
        get {
//            let navController = self.window?.rootViewController?.children[0] as! UINavigationController
//            return navController.topViewController as! ViewController
            let main_storyboard = UIStoryboard(name: "Main", bundle: .main)
            return main_storyboard.instantiateInitialViewController() as! ViewController
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    let locationManager = CLLocationManager()
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        presentAlertController(title: "Location Manager Failed", message: error.localizedDescription, buttonTitle: "Oof")
    }
    
    // MARK: - SPTSessionManagerDelegate
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        //MARK: TODO Fix Bug where authorization failed appears after clicking diconnect and connect due to network connection lost
        presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Bummer")
    }

    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
    }

    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
    
    // MARK: - AppRemoteDelegate
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote = appRemote
        playerViewController.appRemoteConnected()
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("didFailConnectionAttemptWithError")
        playerViewController.appRemoteDisconnected()
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("didDisconnectWithError")
        playerViewController.appRemoteDisconnected()
    }
    
    // MARK: - Private Helpers
    private func presentAlertController(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
            controller.addAction(action)
            self.playerViewController.present(controller, animated: true)
        }
    }
    
    // MARK: - Scene Functions
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
          guard let url = URLContexts.first?.url else {
            return
          }
          sessionManager.application(UIApplication.shared, open: url, options: [:])
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Makes the initial view using the Login.storyboard
        let storyboard = UIStoryboard(name: "Login", bundle: .main)
        if let initialViewController = storyboard.instantiateInitialViewController() {
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // If the sessionManager is active, connect the AppRemote
        //playerViewController.appRemoteConnecting()
        if let _ = self.appRemote.connectionParameters.accessToken {
          self.appRemote.connect()
        }
        playerViewController.updateViewBasedOnConnected()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        //Disconnects the AppRemote when scene is closed
        if (self.appRemote.isConnected) {
            self.appRemote.disconnect()
        }
    }
}

//  Move the spotify config and Manager to a Spotify Client Object
//   //
//   //  SceneDelegate.swift
//   //  Beats
//   //
//   //  Created by Nirav Adunuthula on 6/9/20.
//   //  Copyright © 2020 Nirav Adunuthula. All rights reserved.
//   //
//
//   import UIKit
//
//   class SceneDelegate: UIResponder, UIWindowSceneDelegate, SPTSessionManagerDelegate {
//
//       var window: UIWindow?
//       var spotifyClient : SpotifyClient = SpotifyClient()
//
//       lazy var sessionManager: SPTSessionManager = {
//           let manager = SPTSessionManager(configuration: spotifyClient.getConfiguration(), delegate: self)
//           return manager
//       }()
//
//
//       func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//           guard let _ = (scene as? UIWindowScene) else { return }
//       }
//
//       func sceneDidBecomeActive(_ scene: UIScene) {
//           let requestedScopes: SPTScope = [.appRemoteControl]
//           self.sessionManager.initiateSession(with: requestedScopes, options: .default)
//       }
//
//       func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//         guard let url = URLContexts.first?.url else {
//           return
//         }
//         self.sessionManager.application(UIApplication.shared, open: url, options: [:])
//       }
//
//       // MARK - SPTSessionManagerDelegate
//
//       func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
//           print("success", session)
//       }
//
//       func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
//           print("failed", error)
//       }
//
//       func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
//           print("renewed", session)
//       }
//   }
