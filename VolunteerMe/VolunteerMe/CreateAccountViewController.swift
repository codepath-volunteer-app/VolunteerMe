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

  @IBOutlet weak var animalsTag: UILabel!
  @IBOutlet weak var discriminationTag: UILabel!
  @IBOutlet weak var educationTag: UILabel!
  @IBOutlet weak var elderlyTag: UILabel!
  @IBOutlet weak var environmentTag: UILabel!
  @IBOutlet weak var healthTag: UILabel!
  @IBOutlet weak var homelessnessTag: UILabel!
  @IBOutlet weak var hungerTag: UILabel!
  @IBOutlet weak var youthTag: UILabel!

  var tagLabels: [UILabel] = [UILabel]()

  override func viewDidLoad() {
    super.viewDidLoad()
    titleText.textColor = Color.PRIMARY_COLOR
    subtitleText.textColor = Color.PRIMARY_COLOR
    usernameUnderline.backgroundColor = Color.PRIMARY_COLOR
    passwordUnderline.backgroundColor = Color.PRIMARY_COLOR

    createAccountButtonBackground.backgroundColor = Color.PRIMARY_COLOR
    createAccountButtonBackground.layer.cornerRadius = 8.0
    createAccountButtonBackground.clipsToBounds = true
    createAccountButtonLabel.textColor = Color.WHITE

    tagLabels = [
      animalsTag,
      discriminationTag,
      educationTag,
      elderlyTag,
      environmentTag,
      healthTag,
      homelessnessTag,
      hungerTag,
      youthTag,
    ]

    var i = 0
    for tag in tagLabels {
      tag.tag = i
      tag.backgroundColor = Color.PRIMARY_COLOR
      tag.textColor = Color.WHITE
      tag.text = " " + tag.text! + " "
      tag.layer.cornerRadius = 8.0
      tag.clipsToBounds = true
      tag.isUserInteractionEnabled = true
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tagTapped(gestureRecognizer:)))
      tag.addGestureRecognizer(tapGesture)
      i += 1
    }

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func tagTapped(gestureRecognizer: UITapGestureRecognizer) {
    let tag = tagLabels[gestureRecognizer.view!.tag]
    if tag.backgroundColor == Color.PRIMARY_COLOR {
      tag.backgroundColor = Color.SECONDARY_COLOR
    } else {
      tag.backgroundColor = Color.PRIMARY_COLOR
    }
    // Mark tag as selected
  }

  @IBAction func cancelButtonTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func createAccountButtonTapped(_ sender: Any) {
    // Create account
    var selectedTags: [String] = [String]()
    for tag in tagLabels {
      if tag.backgroundColor == Color.SECONDARY_COLOR {
        selectedTags.append(tag.text!)
      }
    }

    if usernameField.text == nil || usernameField.text == "" {
      createAlert(title: "Oops!", message: "Please choose a username.")
    } else if passwordField.text == nil || passwordField.text == "" {
      createAlert(title: "Oops!", message: "Please choose a password.")
    } else if selectedTags.count == 0 {
      createAlert(title: "Oops!", message: "Don't forget to select a few categories you're interested in!")
    } else {
      User.createNewUser(username: usernameField.text!, password: passwordField.text!, name: usernameField.text, userDescription: nil, userType: .Volunteer, profilePictureUrl: nil, tags: selectedTags) { (user) in
        self.performSegue(withIdentifier: "CreatedAccountSegue", sender: self)
      }
    }
  }

  func createAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
    self.present(alertController, animated: true, completion: nil)
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

