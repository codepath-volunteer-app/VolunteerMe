//
//  OrganizationCreateAccountViewController.swift
//  VolunteerMe
//
//  Created by ruthie_berman on 10/14/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import UIKit

class OrganizationCreateAccountViewController: UIViewController {
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var subtitleText: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var usernameUnderline: UIView!
    @IBOutlet weak var passwordUnderline: UIView!
    @IBOutlet weak var descriptionUnderline: UIView!
    @IBOutlet weak var createAccountButtonBackground: UIView!
    @IBOutlet weak var createAccountButtonText: UILabel!

    @IBOutlet weak var animalsTag: UILabel!
    @IBOutlet weak var educationTag: UILabel!
    @IBOutlet weak var readingTag: UILabel!
    @IBOutlet weak var homelessnessTag: UILabel!
    @IBOutlet weak var womenTag: UILabel!
    @IBOutlet weak var menTag: UILabel!
    @IBOutlet weak var politicsTag: UILabel!
    @IBOutlet weak var hungerTag: UILabel!
    @IBOutlet weak var mediaTag: UILabel!
    
    var tagLabels: [UILabel] = [UILabel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleText.textColor = Color.PRIMARY_COLOR
        subtitleText.textColor = Color.PRIMARY_COLOR
        usernameUnderline.backgroundColor = Color.PRIMARY_COLOR
        passwordUnderline.backgroundColor = Color.PRIMARY_COLOR
        descriptionUnderline.backgroundColor = Color.PRIMARY_COLOR
        
        createAccountButtonBackground.backgroundColor = Color.PRIMARY_COLOR
        createAccountButtonBackground.layer.cornerRadius = 8.0
        createAccountButtonBackground.clipsToBounds = true
        createAccountButtonText.textColor = Color.WHITE

        tagLabels = [
            animalsTag,
            educationTag,
            readingTag,
            homelessnessTag,
            womenTag,
            menTag,
            politicsTag,
            hungerTag,
            mediaTag,
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
            if let tagName = CreateAccountViewController.mapOfTagStringsToTagNames[tag.text!.trimmingCharacters(in:
                [" "])] {
                selectedTags.append(tagName)
            }
        }
      }

      if usernameField.text == nil || usernameField.text == "" {
        createAlert(title: "Oops!", message: "Please choose a username.")
      } else if passwordField.text == nil || passwordField.text == "" {
        createAlert(title: "Oops!", message: "Please choose a password.")
      } else if descriptionField.text == nil || descriptionField.text == "" {
        createAlert(title: "Oops!", message: "Please write a short description about your organization")
      } else if selectedTags.count == 0 {
        createAlert(title: "Oops!", message: "Please select any categories that are relevant to your organization.")
      } else {
        User.createNewUser(username: usernameField.text!, password: passwordField.text!, name: usernameField.text, userDescription: descriptionField.text, userType: .Organization, profilePictureUrl: nil, tags: selectedTags) { (user) in
          self.performSegue(withIdentifier: "orgCreatedAccountSegue", sender: self)
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

