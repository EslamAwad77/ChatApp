//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Laptop World on 28/10/1443 AH.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    //---------------------- outlet ---------------
    
    @IBOutlet weak var txtFieldUserName: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    
    //---------------------- Actions ---------------
    
    @IBAction func btnRegister(_ sender: UIButton) {
        if let email = txtFieldUserName.text, let password = txtFieldPassword.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                }else{
                    
                    let vc = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(identifier: "ChatVC") as! ChattViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    
    //---------------------- LifeCycle ---------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
