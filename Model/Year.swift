//
//  Year.swift
//  Surprix
//
//  Created by Administrator on 16/12/2017.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit
import Firebase

class Year {
    let year: Int
    let id: String
    let producer_id: String
    let producer_color: String
    
    init(year: Int, producer: Producer) {
        self.year = year
        self.producer_id = producer.id
        self.producer_color = producer.color
        self.id = producer_id + "_" + String(year)
    }
    
    init(snap: DataSnapshot){
        let year = snap.value as! [String: Any]
        self.year = year["year"] as! Int
        self.producer_id = year["producerId"] as! String
        self.producer_color = year["producer_color"] as! String
        self.id = year["id"] as! String
    }
}
