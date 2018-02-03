//
//  TimeLine.swift
//  lifelog
//
//  Created by 土井愛己 on 2018/02/03.
//  Copyright © 2018年 aiki.doi. All rights reserved.
//

import Foundation
import RealmSwift

class TimeLine: Object{
    
    dynamic var id = 0
    dynamic var date = NSDate()
    dynamic var latitude = ""
    dynamic var longitude = ""
    dynamic var status = ""
    
    override static func primaryKey() -> String?{
        return "id"
    }
    
}
