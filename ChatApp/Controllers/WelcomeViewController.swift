//
//  WelcomeViewController.swift
//  ChatApp
//
//  Created by Laptop World on 28/10/1443 AH.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
    
    //---------------------- outlet ---------------
    
    @IBOutlet weak var lblChat: CLTypingLabel!
    
    //---------------------- Actions ---------------
    
    @IBAction func btnRegister(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "RegisterVC") as! RegisterViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginVC") as! LoginViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //---------------------- LifeCycle ---------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblChat.text = "My Chat App "
        
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
