//
//  Year.swift
//  Surprix
//
//  Created by Administrator on 16/12/2017.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit

class Set {
    let name: String
    let producer_name: String
    let year: Int
    
    init(name: String, producer_name: String, year: Int) {
        self.year = year
        self.name = name
        self.producer_name = producer_name
    }
}
