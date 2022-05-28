//
//  ViewController.swift
//  ChatApp
//
//  Created by Laptop World on 25/10/1443 AH.
//

import UIKit

class LoginViewController: UIViewController {

    //__________________ Outlet _________________
    @IBOutlet weak var lblUserName: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    
    //__________________ Actions _________________
    
    @IBAction func btnLogin(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ChatVC") as! TableViewController
        navigationController?.pushViewController(vc, animated: true)
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

