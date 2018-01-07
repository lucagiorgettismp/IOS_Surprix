//
//  Year.swift
//  Surprix
//
//  Created by Administrator on 16/12/2017.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit
import Firebase

class Set {
    let id: String
    let name: String
    let year: Int
    let year_id: String
    let product: String
    let producer_name: String
    let producer_color: String
    let nation: String
    let imgPath: String
    let category: String
    
    init(name: String, year: Year, producer: Producer, nation: String, imgPath: String, category: String) {
        self.year = year.year
        self.name = name
        self.producer_name = producer.name
        self.product = producer.product
        self.producer_color = producer.color
        self.year_id = year.id
        self.nation = nation
        self.imgPath = imgPath
        self.category = category
        self.id = name.replacingOccurrences(of: " ", with: "") + "_" + String(describing: year)
    }
    
    init(snap: DataSnapshot){
        let set = snap.value as! [String: Any]
        self.year = set["year"] as! Int
        self.name = set["name"] as! String
        self.producer_name = set["producer_name"] as! String
        self.product = set["product"] as! String
        self.producer_color = set["producer_color"] as! String
        self.year_id = set["year_id"] as! String
        self.nation = set["nation"] as! String
        self.imgPath = set["img_path"] as! String
        self.category = set["category"] as! String
        self.id = set["id"] as! String
    }
}
