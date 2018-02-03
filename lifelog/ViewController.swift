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
    
    @IBOutlet weak var statusDisplay: UILabel!
    @IBOutlet weak var locationDisplay: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var myLocationManager: CLLocationManager!
    var myActivityManeger: CMMotionActivityManager!
    
    let realm = try! Realm()
    var actArray = try! Realm().objects(TimeLine.self).sorted(byKeyPath:"date", ascending:false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //位置情報の取得
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        myLocationManager.distanceFilter = 10
        
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined) {
            print("DEBUG: 位置情報許可未取得です")
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
                                self.statusDisplay.text = "乗車中"
                            } else {
                                self.statusDisplay.text = "静止中"
                            }
                        }
                        if data.walking == true{
                            self.statusDisplay.text = "歩行中"
                        }
                        if data.cycling == true{
                            self.statusDisplay.text = "サイクリング中"
                        }
                        if data.running == true{
                            self.statusDisplay.text = "ランニング中"
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
        locationDisplay.text = "緯度: " + (NSString(format: "%.10f", latitude!) as String) + "\n" + "経度: " + (NSString(format: "%.10f", longitude!) as String)
    }
    
    private func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
        print("error")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
}
