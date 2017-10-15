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
    
  @IBOutlet var loginButtonTapped: UITapGestureRecognizer!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
