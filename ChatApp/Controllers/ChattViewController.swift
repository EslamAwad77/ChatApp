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
    
    //---------------------- Properties ---------------
    
    var messages: [Messages] = []
    
    let dataBase = Firestore.firestore()
    
    //---------------------- outlet ---------------
    
    @IBOutlet weak var tableViewChat: UITableView!
    @IBOutlet weak var txtFieldMessage: UITextField!
    
    //---------------------- Actions ---------------
    
    @IBAction func btnMessagePressed(_ sender: UIButton) {
        if let messageBody = txtFieldMessage.text, let messageSender = Auth.auth().currentUser?.email {
            dataBase.collection("messages").addDocument(data: [
                "sender": messageSender,
                "body": messageBody,
                "date": Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error{
                    print("there is an issue with saving data \(e.localizedDescription)")
                } else {
                    print("successfully saved data")
                }
            }
        }
    }

    //---------------------- LifeCycle ---------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewChat.dataSource = self
        loadMessages()
    }
    
    //---------------------- Functions ---------------
    
    func loadMessages(){
        
        dataBase.collection("messages").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print("there is an issue with retreiving data \(e.localizedDescription)")
            } else {
                if let querySnapshotDocument = querySnapshot?.documents{
                    for doc in querySnapshotDocument{
                        let data = doc.data()
                        if let messageSender = data["sender"] as? String, let messageBody = data["body"] as? String{
                           let newMessage = Messages(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableViewChat.reloadData()
                            }
                        }
                    }
                }
                
            }
        }
    }
}

//---------------------- Extensions ---------------

extension ChattViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.layer.cornerRadius = cell.frame.size.height / 5
        cell.textLabel?.text = messages[indexPath.row].body
        cell.textLabel?.textColor = UIColor(named: "whiteColor")
        
        return cell
    }
    
    
}
