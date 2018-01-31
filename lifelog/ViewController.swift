//
//  ViewController.swift
//  lifelog
//
//  Created by 土井愛己 on 2018/01/31.
//  Copyright © 2018年 aiki.doi. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var statusDisplay: UILabel!
    @IBOutlet weak var locationDisplay: UILabel!
    
    var myLocationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        myLocationManager.distanceFilter = 10
        myLocationManager.startUpdatingLocation()
        
        let auth_status = CLLocationManager.authorizationStatus()
        
        if(auth_status == CLAuthorizationStatus.notDetermined) {
            print("DEBUG: 位置情報許可未取得です")
            self.myLocationManager.requestAlwaysAuthorization()
        }
    
    }

    func locationManager(manager: CLLocationManager!,didUpdateLocations locations: [AnyObject]!){
        locationDisplay.text = "緯度：\(String(describing: manager.location?.coordinate.latitude))" + "緯度：\(String(describing: manager.location?.coordinate.longitude))"
    }
    
    private func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
        print("error")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

