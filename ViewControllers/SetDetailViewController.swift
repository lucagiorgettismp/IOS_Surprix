//
//  MissingsViewController.swift
//  Surprix
//
//  Created by Administrator on 16/12/2017.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SetDetailViewCell : UITableViewCell{
    
    @IBOutlet weak var surpName: UILabel!
    @IBOutlet weak var surpImage: UIImageView!
    
}

class SetDetailViewController: UITableViewController {
    
    var passedValue: String = ""
    var surprises = [Surprise]()
    
    @IBAction func cancel(sender: AnyObject)   {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Serie passata id = " + passedValue)
        self.getSurprisesBySet(setId: passedValue)
    }
    
    func getSurprisesBySet(setId: String) {
        var surprises : [Surprise] = []
        
        let ref = Database.database().reference()
        ref.child("sets").child(setId).child("surprises").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children.allObjects{
                let c = child as! DataSnapshot
                ref.child("surprises").child(c.key).queryOrdered(byChild: "surprise_id").observeSingleEvent(of: .value, with: { (snap) in
                    if (snap.exists()){
                        let surp = Surprise(snap: snap)
                        surprises.append(surp)
                        self.surprises = surprises
                        self.tableView.reloadData()
                    }
                })}
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.surprises.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetDetailCell", for: indexPath) as! SetDetailViewCell

        let surp = self.surprises[indexPath.row]
        
        cell.surpName?.text = surp.description

        let url = URL(string: surp.imgPath)
        
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Errore: " + error.debugDescription)
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                cell.surpImage.image = image
            }
        }
        dataTask.resume()
        
        cell.surpName.backgroundColor = getColorByName(color: surp.set_producer_color)
        
        
        return cell
    }
}
