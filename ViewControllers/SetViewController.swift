//
//  YearViewController.swift
//  Surprix
//
//  Created by Administrator on 19/12/2017.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SetTableViewCell : UITableViewCell {
    @IBOutlet weak var setNameLabel: UILabel!
    @IBOutlet weak var setCountryLabel: UILabel!
    @IBOutlet weak var setImage: UIImageView!
    @IBOutlet weak var stackTitle: UIStackView!
    var setId: String = ""
}

class SetViewController: UITableViewController {
    @IBAction func cancel(sender: AnyObject)   {
        navigationController?.popViewController(animated: true)
    }
    
    var sets = [Set]()
    var passedValue: String = ""
    var valueSelected: String = ""
    
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
        print("Anno Passato id = " + passedValue)
        self.getSetsByYear(yearId: passedValue)
    }
    
    
    func getSetsByYear(yearId: String) {
        var sets : [Set] = []
        
        let ref = Database.database().reference()
        ref.child("years").child(yearId).child("sets").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children.allObjects{
                let c = child as! DataSnapshot
                ref.child("sets").child(c.key).queryOrdered(byChild: "year").observeSingleEvent(of: .value, with: { (snap) in
                    if (snap.exists()){
                        let set = Set(snap: snap)
                        sets.append(set)
                        self.sets = sets
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
        return sets.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath) as! SetTableViewCell
        
        let set = self.sets[indexPath.row]
        cell.setNameLabel?.text = set.name
        cell.setCountryLabel?.text = getCountryNameByCode(code: set.nation)
        cell.setId = set.id
        
        let url = URL(string: set.imgPath)
        
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Errore: " + error.debugDescription)
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                cell.setImage.image = image
            }
        }
        dataTask.resume()
        
        let backgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .yellow
            view.backgroundColor = getColorByName(color: String(set.producer_color))
            return view
        }()
        
        pinBackground(backgroundView, to: cell.stackTitle)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currCell = tableView.cellForRow(at: indexPath) as! SetTableViewCell
        
        self.valueSelected = currCell.setId
        print("Setto value: " + currCell.setId )
        performSegue(withIdentifier: "setSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "setSegue"){
            let nc = segue.destination as! SetDetailViewController
            print("Prendo value: " + self.valueSelected )
            nc.passedValue = self.valueSelected
        }
    }
}
