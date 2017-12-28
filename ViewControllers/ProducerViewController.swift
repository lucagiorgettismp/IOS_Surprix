//
//  ProducerViewController.swift
//  Surprix
//
//  Created by Administrator on 16/12/2017.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit

class ProducerViewController: UITableViewController {

    @IBAction func cancel(sender: AnyObject)   {
        dismiss(animated: true, completion: nil)
    }
    
    var producers: [Producer]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        producers = [Producer]();
        
        producers.append(Producer(name: "Kinder", prod_name: "Sorpresa"))
        producers.append(Producer(name: "Kinder",prod_name: "Merendero"))
        
        tableView.tableFooterView = UIView()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProducerCell", for: indexPath)

        let prod = producers[indexPath.row]
        
        cell.textLabel?.text = prod.name
        cell.detailTextLabel?.text = prod.product_name

        return cell
    }

}
