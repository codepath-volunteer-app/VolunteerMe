//
//  EventDetailsViewController.swift
//  VolunteerMe
//
//  Created by ruthie_berman on 10/15/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var registerButtonBackground: UIView!
    @IBOutlet weak var registerButtonLabel: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var map: UIView!
    
    private var registered: Bool = false
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButtonBackground.backgroundColor = Color.PRIMARY_COLOR
        registerButtonBackground.layer.cornerRadius = 8.0
        registerButtonBackground.clipsToBounds = true
        
        if event != nil {
            titleText.text = event!.name
            eventDate.text = event!.datetime
            eventTime.text = event!.datetime
//            eventImage.setImageWith(URL(string: event!.imageUrl!)!)
            registered = event!.attendees.contains(User.current()!)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        if registered {
            self.createAlert(title: "You're Already Registered", message: "You are already registered for this event. Would you like to cancel?")
        } else {
            event!.registerUser(user: User.current()!, successCallback: { (successfullyRegistered) in
                if successfullyRegistered {
                    self.registered = true
                    self.registerButtonBackground.alpha = 0.5
                    self.createAlert(title: "You are Registered", message: "You have successfully registered to volunteer!")
                } else {
                    self.createAlert(title: "Oops!", message: "There was a problem registering. Try again in a few minutes!")
                }
            })
        }
    }
    
    func createAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alreadyRegisteredAlert() {
        let alertController = UIAlertController(title: "You're Already Registered", message: "You are already registered to volunteer at this event. Would you like to cancel?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "No, I will be there!", style: UIAlertActionStyle.default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes, I'd like to cancel", style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in
            self.registered = false
            self.registerButtonBackground.alpha = 1.0
            //unregister
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

