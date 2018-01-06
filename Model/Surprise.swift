 //
//  Surprise.swift
//  Surprix//
//  Created by Administrator on 16/12/2017.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Surprise {
    let id: String
    let code: String
    let description: String
    let set_year: Int
    let imgPath: String
    let set_name: String
    let set_producer_name: String
    let set_product_name: String
    let set_producer_color: String
    let set_nation: String
    let set_id: String
    
    init(code: String, description: String, imgPath: String, set: Set) {
        self.code = code
        self.description = description
        self.set_year = set.year
        self.imgPath = imgPath
        self.set_name = set.name
        self.set_producer_name = set.producer_name
        self.set_product_name = set.product
        self.set_nation = set.nation
        self.set_id = set.id
        self.set_producer_color = set.producer_color
        self.id = set_producer_name + "_" + String(set_year) + "_" + code
    }
    
    init(snap: DataSnapshot){
        let surprise = snap.value as! [String: Any]
        self.code = surprise["code"] as! String
        self.description = surprise["description"] as! String
        self.set_year = surprise["set_year"] as! Int
        self.imgPath = surprise["img_path"] as! String
        self.set_name = surprise["set_name"] as! String
        self.set_producer_name = surprise["set_producer_name"] as! String
        self.set_product_name = surprise["set_product_name"] as! String
        self.set_nation = surprise["set_nation"] as! String
        self.set_id = surprise["set_id"] as! String
        self.set_producer_color = surprise["set_producer_color"] as! String
        self.id = surprise["id"] as! String
    }
}
