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
    @IBOutlet weak var surpAddDoubles: UIButton!
    @IBOutlet weak var stackTitle: UIStackView!
    @IBOutlet weak var surpAddMissings: UIButton!
    var surpId: String = ""
}

class SetDetailViewController: UITableViewController {
    
    var passedValue: String = ""
    var surprises = [Surprise]()
    
    @IBAction func cancel(sender: AnyObject)   {
        dismiss(animated: true, completion: nil)
    }
    
    private func pinBackground(_ view: UIView, to stackView: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertSubview(view, at: 0)
        view.pin(to: stackView)
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
        
        cell.surpName?.text = surp.code + " - " + surp.description

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
        
        let backgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .yellow
            view.backgroundColor = getColorByName(color: String(surp.set_producer_color))
            return view
        }()
        
        pinBackground(backgroundView, to: cell.stackTitle)
        
        cell.surpAddMissings.tag = indexPath.row
        cell.surpAddDoubles.tag = indexPath.row
        cell.surpId = surp.id
        return cell
    }
    
    @IBAction func addMissingClicked(sender: UIButton){
        let row = sender.tag
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! SetDetailViewCell
        self.addMissing(surpriseId: cell.surpId)
    }
    
    @IBAction func addDoubleClicked(sender: UIButton){
        let row = sender.tag
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! SetDetailViewCell
        self.addDouble(surpriseId: cell.surpId)
    }
    
    func addMissing(surpriseId: String){
        let ref = Database.database().reference()
        ref.child("missings").child(Variables.username).child(surpriseId).setValue(true)
    }
    
    func addDouble(surpriseId: String){
        let ref = Database.database().reference()
        ref.child("user_doubles").child(Variables.username).child(surpriseId).setValue(true)
        ref.child("surprise_doubles").child(surpriseId).child(Variables.username).setValue(true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
}
