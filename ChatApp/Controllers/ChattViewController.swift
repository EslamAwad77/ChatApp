//
//  ClassViewController.swift
//  ChatApp
//
//  Created by Laptop World on 28/10/1443 AH.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class ChattViewController: UIViewController {
    
    @IBOutlet weak var tableViewChat: UITableView!
    @IBOutlet weak var txtFieldMessage: UITextField!
    
    @IBAction func btnMessagePressed(_ sender: UIButton) {
        
    }
    
    var messages: [Messages] = [
        Messages(sender: "eslam@awad.com", body: "hey!"),
        Messages(sender: "ahmed@ayman", body: "hello"),
        Messages(sender: "eslam@awad.com", body: "how are you")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewChat.dataSource = self
    }
}

extension ChattViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.layer.cornerRadius = cell.frame.size.height / 5
        cell.textLabel?.text = messages[indexPath.row].body
        return cell
    }
    
    
}
