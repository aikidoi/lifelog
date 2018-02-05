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
import CoreMotion

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var myLocationManager: CLLocationManager!
    var myActivityManeger: CMMotionActivityManager!
    var activity_status: String!

    
    let realm = try! Realm()
    var timeLine: TimeLine
    var actArray = try! Realm().objects(TimeLine.self).sorted(byKeyPath:"id", ascending:false)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        //位置情報の取得
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        myLocationManager.distanceFilter = 10
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined) {
            self.myLocationManager.requestAlwaysAuthorization()
        }
        myLocationManager.startUpdatingLocation()
        
        //アクティビティ情報の取得
        myActivityManeger = CMMotionActivityManager()

        if(CMMotionActivityManager.isActivityAvailable() == true) {
            
            func update(data: CMMotionActivity?) {
                guard let data = data else {
                    return
                }
                DispatchQueue.main.async {
                    if data.stationary == true{
                        if data.automotive == true{
                           self.activity_status = "乗車中"
                        } else {
                            self.activity_status = "静止中"
                        }
                    }
                    if data.walking == true{
                        self.activity_status = "歩行中"
                    }
                    if data.cycling == true{
                        self.activity_status = "サイクリング中"
                    }
                    if data.running == true{
                        self.activity_status = "ランニング中"
                    }
                }
            }
            myActivityManeger.startActivityUpdates(to: OperationQueue.current!, withHandler: update)
        }else{
            print("DEBUG: Motion利用不可")
        }
        
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        let now = NSDate()
        typealias CLLocationDegrees = Double
        try! realm.write {
            self.timeLine.date = now
            self.timeLine.latitude = latitude
            self.timeLine.longitude = longitude
            self.timeLine.status = activity_status
        }
    }
    
    private func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
        print("error")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }

    override func viewWillDisappear(_ animated: Bool) {

    }
}
