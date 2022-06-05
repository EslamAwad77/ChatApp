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
import FirebaseStorage

class ChattViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let storage = Storage.storage().reference()
    
    //---------------------- Properties ---------------
    var imgRoom = UIImageView()
    var messages: [Messages] = []
    
    let dataBase = Firestore.firestore()
    
    //---------------------- outlet ---------------
    
    @IBOutlet weak var tableViewChat: UITableView!
    @IBOutlet weak var txtFieldMessage: UITextField!
    
    //---------------------- Actions ---------------
    
    @IBAction func btnMessagePressed(_ sender: UIButton) {
        
        if let messageBody = txtFieldMessage.text, let messageSender = Auth.auth().currentUser?.email{
            dataBase.collection("messages").addDocument(data: [
                "sender": messageSender,
                "body": messageBody,
                "type": MessageType.text.rawValue,
                "date": Date()//.timeIntervalSince1970
            ]) { (error) in
                if let e = error{
                    print("there is an issue with saving data \(e.localizedDescription)")
                } else {
                    print("successfully saved data")
                    DispatchQueue.main.async {
                        self.txtFieldMessage.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func btnImageMessage(_ sender: UIButton) {
        let alert = UIAlertController.init(title: "Select Photo", message: "Choose", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Gallery", style: .default, handler: { (action) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { (action) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //---------------------- LifeCycle --------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMessages()
        setupUI()
    }
    
    //---------------------- Functions ---------------
   
    func setupUI() {
        tableViewChat.dataSource = self
        tableViewChat.delegate = self
        self.tableViewChat.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        self.tableViewChat.register(UINib.init(nibName: "TableViewCellForImage", bundle: nil), forCellReuseIdentifier: "TableViewCellForImage")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imgRoom.image  = tempImage
        
        let storageManager: StorageManager = StorageManager()
        storageManager.uploadProfilePicture(with: tempImage.jpegData(compressionQuality: 0.5)!,
                                            fileName: "\(Date().timeIntervalSince1970).png") { [weak self] (result) in
            //url save it as document with type imag
            guard let self = self else {return}
            switch result {
            case .success(let val):
                
                self.dataBase.collection("messages").addDocument(data: [
                    "sender": Auth.auth().currentUser?.email?.description,
                    "body": val,
                    "type": MessageType.image.rawValue,
                    "date": Date()//.timeIntervalSince1970
                ]) { (error) in
                    if let e = error{
                        print("there is an issue with saving data \(e.localizedDescription)")
                    } else {
                        print("successfully saved data")
                        DispatchQueue.main.async {
                            self.txtFieldMessage.text = ""
                        }
                    }
                }
                break
            case .failure(let err):
                break
            }
            print(result)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func loadMessages(){
        
        dataBase.collection("messages").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print("there is an issue with retreiving data \(e.localizedDescription)")
            } else {
                if let querySnapshotDocument = querySnapshot?.documents{
                    for doc in querySnapshotDocument{
                        let data = doc.data()
                        if let messageSender = data["sender"] as? String, let messageBody = data["body"] as? String {
                            let type = data["type"] as? String
                            var newMessage: Messages!
                            if type == MessageType.image.rawValue {
                                newMessage = Messages(sender: messageSender, body: messageBody, type: .image)
                            }else {
                                newMessage = Messages(sender: messageSender, body: messageBody, type: .text)
                            }
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableViewChat.reloadData()
                                //let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                //self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
}

//---------------------- Extensions ---------------


extension ChattViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        if messages[indexPath.row].sender == Auth.auth().currentUser?.email {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            if message.type == .image{
                cell.imgViewMyMessage.isHidden = false
                cell.lblMyMessage.isHidden = true
                let url = URL.init(string: messages[indexPath.row].body)
                cell.imgViewMyMessage.kf.setImage(with: url)
                //cell.backgroundColor = UIColor.white
            } else {
                cell.lblMyMessage.text = messages[indexPath.row].body
                cell.lblMyMessage.backgroundColor = UIColor.blue
            }
            return cell
        } else {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "TableViewCellForImage", for: indexPath) as! TableViewCellForImage
            if message.type == .image{
                cell2.imgViewYourMessage.isHidden = false
                cell2.lblYourMessage.isHidden = true
                let url = URL.init(string: messages[indexPath.row].body)
                cell2.imgViewYourMessage.kf.setImage(with: url)
                //cell.backgroundColor = UIColor.white
            } else {
                cell2.lblYourMessage.text = messages[indexPath.row].body
                cell2.lblYourMessage.backgroundColor = UIColor.gray
            }
            return cell2
        }
                
//        if message.type == .image{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
//            cell.imgViewMyMessage.isHidden = false
//            cell.lblMyMessage.isHidden = true
//
//            let url = URL.init(string: messages[indexPath.row].body)
//            if messages[indexPath.row].sender == Auth.auth().currentUser?.email {
//                cell.imgViewMyMessage.kf.setImage(with: url)
//                cell.backgroundColor = UIColor.white
//            } else {
//                cell.imgViewMyMessage.kf.setImage(with: url)
//                cell.backgroundColor = UIColor.white
//            }
//
//            return cell
//        }
//
//        let cell2 = tableView.dequeueReusableCell(withIdentifier: "TableViewCellForImage", for: indexPath) as! TableViewCellForImage
//
//        if message.type == .text {
//
//            cell2.lblYourMessage.isHidden = false
//            if messages[indexPath.row].sender == Auth.auth().currentUser?.email {
//                cell2.lblYourMessage.text = messages[indexPath.row].body
//                cell2.lblYourMessage.backgroundColor = UIColor.blue
//            } else {
//                cell2.lblYourMessage.text = messages[indexPath.row].body
//                cell2.lblYourMessage.backgroundColor = UIColor.gray
//            }
//
//        }
//
//        return cell2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = messages[indexPath.row].type
        if type == MessageType.image {
            return 250
        }else {
            return UITableView.automaticDimension
        }
    }
}
