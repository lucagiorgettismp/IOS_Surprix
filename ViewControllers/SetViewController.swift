//
//  YearViewController.swift
//  Surprix
//
//  Created by Administrator on 19/12/2017.
//  Copyright © 2017 Luca Giorgetti. All rights reserved.
//

import UIKit

class SetTableViewCell : UITableViewCell {
    @IBOutlet weak var setNameLabel: UILabel!
    @IBOutlet weak var setCountryLabel: UILabel!
    @IBOutlet weak var setImage: UIImageView!
    @IBOutlet weak var stackTitle: UIStackView!
}

class SetViewController: UITableViewController {

    @IBAction func cancel(sender: AnyObject)   {
        dismiss(animated: true, completion: nil)
    }
    
    var sets: [Set]!
    
    private func pinBackground(_ view: UIView, to stackView: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertSubview(view, at: 0)
        view.pin(to: stackView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath) as! SetTableViewCell
        
        let set = self.sets[indexPath.row]
        cell.setNameLabel?.text = set.name
        cell.setCountryLabel?.text = getCountryNameByCode(code: set.nation)
        
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
}
