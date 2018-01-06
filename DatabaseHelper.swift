//
//  DatabaseHelper.swift
//  Surprix
//
//  Created by Administrator on 02/01/2018.
//  Copyright © 2018 Luca Giorgetti. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DatabaseHelper {
    
    var ref : DatabaseReference!
    
    init() {
        ref = Database.database().reference()
    }
    
    func getMissings(username: String, controller: MissingsViewController) {
        
        var pippo : [Surprise] = []
        
        ref.child("missings").child("lucagiorgit").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children.allObjects{
                let c = child as! DataSnapshot
                self.ref.child("surprises").child(c.key).queryOrdered(byChild: "code").observeSingleEvent(of: .value, with: { (snap) in
                    if (snap.exists()){
                        let surp = Surprise(snap: snap )
                        pippo.append(surp)
                        print("pippo count" + String(pippo.count))
                    }
                })}
            //controller.refreshList(pippo: pippo)
        })
    }
    /*
     
     func getMissings(username: String, completionHandler: @escaping (_ pippo: ([Surprise]?)) -> Void) {
     
     var pippo : [Surprise] = []
     
     ref.child("missings").child("lucagiorgit").observeSingleEvent(of: .value, with: { (snapshot) in
     
     for child in snapshot.children.allObjects{
     let c = child as! DataSnapshot
     self.ref.child("surprises").child(c.key).queryOrdered(byChild: "code").observeSingleEvent(of: .value, with: { (snap) in
     if (snap.exists()){
     let surp = Surprise(snap: snap )
     pippo.append(surp)
     }
     })}
     if pippo.isEmpty {
     print("pippo: nil")
     completionHandler(nil)
     } else {
     print("pippo: " + String(pippo.count))
     completionHandler(pippo)
     }
     })
     }
     
     */

}
