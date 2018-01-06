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
}

public extension UIView {
    public func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

class MissingsViewController: UITableViewController {
   
    var missings = [Surprise]()
    
    private func pinBackground(_ view: UIView, to stackView: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertSubview(view, at: 0)
        view.pin(to: stackView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getMissingData(username: "lucagiorgit")
    }
    
    
    func getMissingData(username: String) {
        var missings : [Surprise] = []
        
        let ref = Database.database().reference()
        
        ref.child("missings").child("lucagiorgit").observeSingleEvent(of: .value, with: { (snapshot) in
            
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
        
        let backgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .yellow
            view.backgroundColor = getColorByName(color: String(surp.set_producer_color))
            return view
        }()
        
        pinBackground(backgroundView, to: cell.stackTitle)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90;
    }
}
