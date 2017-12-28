//
//  MissingsViewController.swift
//  Surprix
//
//  Created by Administrator on 16/12/2017.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit

class SetDetailViewController: UITableViewController {
    var surprises: [Surprise]!
    
    @IBAction func cancel(sender: AnyObject)   {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        surprises = [Surprise]()
        surprises.append(Surprise(code: "SD112", description: "Pippo", year: 2016))
        surprises.append(Surprise(code: "SD113", description: "Pluto", year: 2016))
        surprises.append(Surprise(code: "SD114", description: "Paperino", year: 2016))
        surprises.append(Surprise(code: "SD115", description: "Pierino", year: 2016))
        tableView.tableFooterView = UIView()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetDetailCell", for: indexPath)

        let surp = self.surprises[indexPath.row]
        
        cell.textLabel?.text = surp.descr
        cell.detailTextLabel?.text = surp.code

        return cell
    }
}
