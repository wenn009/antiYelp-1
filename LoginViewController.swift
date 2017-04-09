//
//  LoginViewController.swift
//  Yelp
//
//  Created by Wenn Huang on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import Parse


class LoginViewController: UIViewController {

    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onSignInButton(_ sender: UIButton) {
        
        PFUser.logInWithUsername(inBackground: emailLabel.text!, password: passwordLabel.text!) { (user : PFUser?, error: Error?) in
            if (user != nil){
                print("works")
                self.performSegue(withIdentifier: "toviewcontroller", sender: nil)
            }
            else{
                print(error?.localizedDescription)
            }
        }
    }
    
    @IBOutlet weak var onSignUpButton: UIButton!

    @IBAction func onSignUpButton(_ sender: UIButton) {
        
        let newUser = PFUser()
        
        newUser.email = emailLabel.text
        newUser.username = emailLabel.text
        newUser.password = passwordLabel.text
        
        newUser.signUpInBackground { (success: Bool, error: Error?) -> Void in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User Registered successfully")
                self.performSegue(withIdentifier: "toviewcontroller", sender: nil)
                // manually segue to logged in view
            }
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
