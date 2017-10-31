//
//  OrganizationLoginViewController.swift
//  VolunteerMe
//
//  Created by ruthie_berman on 10/14/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import UIKit

class OrganizationLoginViewController: UIViewController {

  @IBOutlet weak var titleText: UILabel!
  @IBOutlet weak var subtitleText: UILabel!
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var usernameUnderline: UIView!
  @IBOutlet weak var passwordUnderline: UIView!
  @IBOutlet weak var loginButtonBackground: UIView!
  @IBOutlet weak var loginButtonText: UILabel!
  @IBOutlet weak var createAccountButtonBackground: UIView!
  @IBOutlet weak var createAccountButtonText: UILabel!



    override func viewDidLoad() {
        super.viewDidLoad()
      titleText.textColor = Color.PRIMARY_COLOR
      subtitleText.textColor = Color.PRIMARY_COLOR
      usernameUnderline.backgroundColor = Color.PRIMARY_COLOR
      passwordUnderline.backgroundColor = Color.PRIMARY_COLOR

      loginButtonBackground.backgroundColor = Color.PRIMARY_COLOR
      loginButtonBackground.layer.cornerRadius = 8.0
      loginButtonBackground.clipsToBounds = true
      loginButtonText.textColor = Color.WHITE

      createAccountButtonBackground.backgroundColor = Color.WHITE
      createAccountButtonBackground.layer.cornerRadius = 8.0
      createAccountButtonBackground.layer.borderColor = Color.PRIMARY_COLOR.cgColor
      createAccountButtonBackground.layer.borderWidth = 2.0
      createAccountButtonBackground.clipsToBounds = true
      createAccountButtonText.textColor = Color.PRIMARY_COLOR
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  @IBAction func loginButtonTapped(_ sender: Any) {
    if usernameField.text == nil || usernameField.text == "" {
      createAlert(title: "Oops!", message: "Please enter your username.")
    } else if passwordField.text == nil || passwordField.text == "" {
      createAlert(title: "Oops!", message: "Please enter your password.")
    } else {
      User.login(username: usernameField.text!, password: passwordField.text!, successCallback: {
        (user) in
        self.onSuccess()
      }) {
        (error: Error) in
        self.createAlert(title: "Oops!", message: "That username and password combination doesn't already have an account. Tap 'Create Account' to make a new account.")
      }
    }
  }

  func createAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }

  func onSuccess() {
    self.performSegue(withIdentifier: "orgLoginSegue", sender: self)
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
