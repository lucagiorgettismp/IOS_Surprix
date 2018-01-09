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


class MissingsTableViewCell: UITableViewCell {
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

class MissingsViewController: UITableViewController {
   
    var missings = [Surprise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            print("1. utente trovato")
            let ref = Database.database().reference()
            let emailCod = Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: ",")
            ref.child("emails").child(emailCod!).observeSingleEvent(of: .value, with: { (snap) in
                for child in snap.children.allObjects{
                    let c = child as! DataSnapshot
                    let username = c.key
                    Variables.username = username
                    print("2. username settato")
                    print("3. cerco")
                    self.getMissingData(username: Variables.username)
                }
            })
        } else {
            print("manca")
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(controller!, animated: true, completion: nil)
        }

        super.viewDidAppear(animated)
    }
    
    
    func getMissingData(username: String) {
        var missings : [Surprise] = []
        
        let ref = Database.database().reference()
        print("4. cerco con: " + Variables.username)
        ref.child("missings").child(Variables.username).observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children.allObjects{
                let c = child as! DataSnapshot
                ref.child("surprises").child(c.key).queryOrdered(byChild: "code").observeSingleEvent(of: .value, with: { (snap) in
                    if (snap.exists()){
                        let surp = Surprise(snap: snap )
                        missings.append(surp)
                        self.missings = missings
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
        return self.missings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MissingCell", for: indexPath) as! MissingsTableViewCell

        let surp = self.missings[indexPath.row]
        
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
        cell.backgroundTitle.backgroundColor = getColorByName(color: String(surp.set_producer_color))
        pinBackground(cell.backgroundTitle, to: cell.stackTitle)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90;
    }
    
    func removeFromMissings(surpriseId: String){
        let ref = Database.database().reference()
        ref.child("missings").child(Variables.username).child(surpriseId).setValue(nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MissingsTableViewCell
        let alert = UIAlertController(title: "Remove item", message: "Do you want to remove clicked item?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.removeFromMissings(surpriseId: cell.surpId);
            self.viewDidAppear(true)
        }))
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: { action in
            self.tableView.deselectRow(at: indexPath, animated: true)  
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logout(){
        do{
            try Auth.auth().signOut()
            self.viewDidAppear(true)
        } catch {
            print("Errore nel logout")
        }
    }
}
