//
//  YearViewController.swift
//  Surprix
//
//  Created by Administrator on 19/12/2017.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit

class SetViewController: UITableViewController {

    @IBAction func cancel(sender: AnyObject)   {
        dismiss(animated: true, completion: nil)
    }
    
    var sets: [Set]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sets = [Set]();
        sets.append(Set(name: "Puffi", producer_name: "Kinder", year: 2016));
        sets.append(Set(name: "Cattivissimo Me 3", producer_name: "Kinder", year: 2017));
        
        tableView.tableFooterView = UIView()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath)
        
        let set = self.sets[indexPath.row]
        cell.textLabel?.text = set.name
        cell.detailTextLabel?.text = String(set.year)
        
        return cell
    }
}
