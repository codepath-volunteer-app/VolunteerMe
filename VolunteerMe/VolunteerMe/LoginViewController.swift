//
//  LoginViewController.swift
//  VolunteerMe
//
//  Created by ruthie_berman on 10/13/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

  @IBOutlet weak var titleText: UILabel!
  @IBOutlet weak var subtitleText: UILabel!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
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
    if usernameTextField.text == nil || usernameTextField.text == "" {
      createAlert(title: "Oops!", message: "Please enter your username.")
    } else if passwordTextField.text == nil || passwordTextField.text == "" {
      createAlert(title: "Oops!", message: "Please enter your password.")
    } else {
        User.login(username: usernameTextField.text!, password: passwordTextField.text!, successCallback: {
            (user) in
            self.onSuccess()
        }) {
            (error: Error) in
                self.createAlert(title: "Oops!", message: "We had trouble logging you into your account. If you want to make a new account, tap 'Create Account'.  Error message: \(error.localizedDescription).")
      }
    }
  }

  func createAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }

  func onSuccess() {
    self.performSegue(withIdentifier: "LoginSegue", sender: self)
  }


  // MARK: - Navigation
/*
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.identifier == "CreateAccountSegue" {
      let navController = segue.destination as! UINavigationController
      let createAccountController = navController.topViewController as! CreateAccountViewController
      createAccountController.completionHandler = { self.onSuccess() }
    }
  }
 */
}

