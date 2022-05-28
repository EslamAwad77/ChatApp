//
//  ViewController.swift
//  ChatApp
//
//  Created by Laptop World on 25/10/1443 AH.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    //__________________ Outlet _________________
    
    @IBOutlet weak var txtFieldLogin: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    
    
    //__________________ Actions _________________
    
    @IBAction func btnLogin(_ sender: UIButton) {
        if let email = txtFieldLogin.text, let password = txtFieldPassword.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                }else{
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ChatVC") as! ChattViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    
    //__________________ LifeCycle _________________
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }


}

