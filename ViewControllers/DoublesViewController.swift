//
//  MissingsViewController.swift
//  Surprix
//
//  Created by Administrator on 08/01/2018.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class DoublesTableViewCell: UITableViewCell {
    @IBOutlet weak var surpriseImage: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var stackTitle: UIStackView!
    var surpId: String = ""
    
    var backgroundTitle: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
}

class DoublesViewController: UITableViewController {
   
    var doubles = [Surprise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getDoublesData(username: Variables.username)
    }
    
    func getDoublesData(username: String) {
        var doubles : [Surprise] = []
        
        let ref = Database.database().reference()
        ref.child("user_doubles").child(Variables.username).observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children.allObjects{
                let c = child as! DataSnapshot
                ref.child("surprises").child(c.key).queryOrdered(byChild: "code").observeSingleEvent(of: .value, with: { (snap) in
                    if (snap.exists()){
                        let surp = Surprise(snap: snap )
                        doubles.append(surp)
                        self.doubles = doubles
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
        return self.doubles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleCell", for: indexPath) as! DoublesTableViewCell

        let surp = self.doubles[indexPath.row]
        
        cell.codeLabel?.text = surp.code
        cell.descriptionLabel?.text = surp.description
        cell.yearLabel?.text = String(surp.set_year)
        cell.setLabel?.text = surp.set_name
        cell.surpId = surp.id
        
        cell.countryLabel?.text = getCountryNameByCode(code: surp.set_nation)

        cell.producerLabel?.text = surp.set_producer_name
        let url = URL(string: surp.imgPath)
        
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Errore: " + error.debugDescription)
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                cell.surpriseImage.image = image
            }
        }
        dataTask.resume()
        cell.backgroundTitle.backgroundColor = getColorByName(color: surp.set_producer_color)
        pinBackground(cell.backgroundTitle, to: cell.stackTitle)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90;
    }
    
    func removeFromDoubles(surpriseId: String){
        let ref = Database.database().reference()
        ref.child("user_doubles").child(Variables.username).child(surpriseId).setValue(nil)
        ref.child("surprise_doubles").child(surpriseId).child(Variables.username).setValue(nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DoublesTableViewCell
        let alert = UIAlertController(title: "Remove item", message: "Do you want to remove clicked item?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.removeFromDoubles(surpriseId: cell.surpId);
            self.viewDidAppear(false)
        }))
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
