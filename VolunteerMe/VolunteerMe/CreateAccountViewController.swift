//
//  CreateAccountViewController.swift
//  VolunteerMe
//
//  Created by ruthie_berman on 10/14/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

  @IBOutlet weak var titleText: UILabel!
  @IBOutlet weak var subtitleText: UILabel!
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var usernameUnderline: UIView!
  @IBOutlet weak var passwordUnderline: UIView!
  @IBOutlet weak var createAccountButtonBackground: UIView!
  @IBOutlet weak var createAccountButtonLabel: UILabel!
  @IBOutlet weak var tagsView: UIView!
  @IBOutlet var tags: [UILabel]!


    override func viewDidLoad() {
        super.viewDidLoad()
      titleText.textColor = Color.PRIMARY_COLOR
      subtitleText.textColor = Color.PRIMARY_COLOR
      usernameUnderline.backgroundColor = Color.PRIMARY_COLOR
      passwordUnderline.backgroundColor = Color.PRIMARY_COLOR
      createAccountButtonBackground.backgroundColor = Color.PRIMARY_COLOR
      createAccountButtonBackground.layer.cornerRadius = 8.0
      createAccountButtonBackground.clipsToBounds = true
      createAccountButtonLabel.textColor = Color.PRIMARY_COLOR

      var i = 0
      for tag in tags {
        tag.tag = i
        tag.backgroundColor = Color.PRIMARY_COLOR
        tag.textColor = Color.WHITE
        tag.layer.cornerRadius = 8.0
        tag.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tagTapped"))
        tag.addGestureRecognizer(tapGesture)
        i += 1
      }
        // Do any additional setup after loading the view.
    }

  @objc func tagTapped(gestureRecognizer: UIGestureRecognizer) {
    let tag = tags[gestureRecognizer.view!.tag]
    if tag.backgroundColor == Color.PRIMARY_COLOR {
      tag.backgroundColor = Color.SECONDARY_COLOR
    } else {
      tag.backgroundColor = Color.PRIMARY_COLOR
    }
    // Mark tag as selected
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func cancelButtonTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func createAccountButtonTapped(_ sender: Any) {
    // Create account
    dismiss(animated: true, completion: nil)
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
