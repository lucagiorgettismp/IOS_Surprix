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

class YearTableViewCell: UITableViewCell {

    @IBOutlet weak var yearLabel: UILabel!
    var yearId: String = ""
}


class YearViewController: UITableViewController {
    var passedValue: String = ""
    var valueSelected: String = ""
    
    @IBAction func cancel(sender: AnyObject)   {
        navigationController?.popViewController(animated: true)
    }
    
    var years = [Year]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("apertura: value = " + self.passedValue)
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getYearsByProducer(producerId: passedValue)
    }
    
    
    func getYearsByProducer(producerId: String) {
        var years : [Year] = []
        
        let ref = Database.database().reference()
        ref.child("producers").child(producerId).child("years").queryOrdered(byChild: "year").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children.allObjects{
                let c = child as! DataSnapshot
                ref.child("years").child(c.key).observeSingleEvent(of: .value, with: { (snap) in
                    if (snap.exists()){
                        let year = Year(snap: snap )
                        years.append(year)
                        self.years = years
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
        return years.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YearCell", for: indexPath) as! YearTableViewCell
        
        let year = self.years[indexPath.row]
        
        cell.yearLabel?.text = String(year.year)
        cell.yearId = year.id
        cell.contentView.backgroundColor = getColorByName(color: year.producer_color)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currCell = tableView.cellForRow(at: indexPath) as! YearTableViewCell
        
        self.valueSelected = currCell.yearId
        print("Setto value: " + currCell.yearId )
        performSegue(withIdentifier: "yearSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "yearSegue"){
            let navCont = segue.destination as! SetViewController
            print("Prendo value: " + self.valueSelected )
            navCont.passedValue = self.valueSelected
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
}
