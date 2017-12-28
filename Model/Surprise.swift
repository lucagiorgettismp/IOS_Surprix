 //
//  Surprise.swift
//  Surprix
//
//  Created by Administrator on 16/12/2017.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit

class Surprise {
    let code: String
    let descr: String
    let year: Int
    
    init(code: String, description: String, year: Int) {
        self.code = code
        self.descr = description
        self.year = year
    }
}
