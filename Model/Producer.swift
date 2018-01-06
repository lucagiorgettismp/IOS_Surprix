//
//  Producer.swift
//  Surprix
//
//  Created by Administrator on 16/12/2017.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit
import Firebase

class Producer {
    let name: String
    let product: String
    let id: String
    let color: String
    let order: Int
    
    init(name: String, prod_name: String, order: Int, color: String) {
        self.name = name
        self.product = prod_name
        self.color = color
        self.order = order
        self.id = name + "_" + product
    }
    
    init(snap: DataSnapshot){
        let producer = snap.value as! [String: Any]
        self.name = producer["name"] as! String
        self.product = producer["product"] as! String
        self.color = producer["color"] as! String
        
        if producer["order"] == nil {
            self.order = 0
        } else {
        self.order = producer["order"] as! Int
        }
        self.id = producer["id"] as! String
    }
    
}
