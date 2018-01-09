//
//  ProducerViewController.swift
//  Surprix
//
//  Created by Administrator on 16/12/2017.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ProducersTableViewCell : UITableViewCell{
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    var producerId: String = ""
}


class ProducerViewController: UITableViewController {

    @IBAction func cancel(sender: AnyObject)   {
        dismiss(animated: true, completion: nil)
    }
    
    var producers = [Producer]()
    var valueSelected: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        self.getProducers()
    }
    
    func getProducers(){
        var producers : [Producer] = []
        
        let ref = Database.database().reference()
        
        ref.child("producers").queryOrdered(byChild: "order").observeSingleEvent(of: .value, with: {(snapshot) in
            
            for child in snapshot.children.allObjects{
                let c = child as! DataSnapshot
                let prod = Producer(snap: c)
                producers.append(prod)
                
                self.producers = producers
                self.tableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return producers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProducerCell", for: indexPath) as! ProducersTableViewCell

        let prod = producers[indexPath.row]
        
        cell.producerLabel?.text = prod.name
        cell.productLabel?.text = prod.product
        cell.producerId = prod.id
        
        cell.contentView.backgroundColor = getColorByName(color: prod.color)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currCell = tableView.cellForRow(at: indexPath) as! ProducersTableViewCell
        
        self.valueSelected = currCell.producerId
        print("Setto value: " + currCell.producerId )
        performSegue(withIdentifier: "producerSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "producerSegue"){
            let navCont = segue.destination as! YearViewController
            print("Prendo value: " + self.valueSelected )
            navCont.passedValue = self.valueSelected
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }

}
