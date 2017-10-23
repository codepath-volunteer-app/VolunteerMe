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
    
    var tagLabels: [UILabel] = [UILabel]()
    var onSuccess: (() -> ())?
    
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
        
        var i = 0
        print(i)
        for view in tagsView.subviews {
            if let tag = view as? UILabel {
                tag.tag = i
                tag.backgroundColor = Color.PRIMARY_COLOR
                tag.textColor = Color.WHITE
                tag.layer.cornerRadius = 8.0
                tag.clipsToBounds = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tagTapped))
                tag.addGestureRecognizer(tapGesture)
                i += 1
                tagLabels.append(tag)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func tagTapped(gestureRecognizer: UIGestureRecognizer) {
        print("TAPPED")
        let tag = tagLabels[gestureRecognizer.view!.tag]
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
        var selectedTags: [String] = [String]()
        for tag in tagLabels {
            if tag.backgroundColor == Color.SECONDARY_COLOR {
                selectedTags.append(tag.text!)
            }
        }
        User.createNewUser(username: usernameField.text!, password: passwordField.text!, name: usernameField.text, userDescription: nil, userType: .Volunteer, profilePictureUrl: nil, tags: selectedTags) { (user) in
            self.onSuccess?()
//            self.dismiss(animated: true, completion: nil)
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

