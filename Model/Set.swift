//
//  Year.swift
//  Surprix
//
//  Created by Administrator on 16/12/2017.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit

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
}
