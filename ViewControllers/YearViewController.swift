//
//  YearViewController.swift
//  Surprix
//
//  Created by Administrator on 19/12/2017.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit

class YearViewController: UITableViewController {

    @IBAction func cancel(sender: AnyObject)   {
        dismiss(animated: true, completion: nil)
    }
    
    var years: [Year]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        years = [Year]();
        years.append(Year(year: 2017));
        years.append(Year(year: 2016));
        
        tableView.tableFooterView = UIView()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "YearCell", for: indexPath)
        
        let year = self.years[indexPath.row]
        
        cell.textLabel?.text = String(year.year)
        
        return cell
    }
}
