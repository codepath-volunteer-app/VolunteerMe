//
//  EventDetailsViewController.swift
//  VolunteerMe
//
//  Created by ruthie_berman on 10/15/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import UIKit
import MapKit

protocol EventDetailsViewControllerDelegate {
    func onUnregister() -> ()
}

class EventDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var registerButton: UIView!
    @IBOutlet weak var registerButtonBackground: UIView!
    @IBOutlet weak var registerButtonLabel: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var map: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    var delegate: EventDetailsViewControllerDelegate?
    private var registered: Bool = false
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButtonBackground.backgroundColor = Color.PRIMARY_COLOR
        registerButtonBackground.layer.cornerRadius = 8.0
        registerButtonBackground.clipsToBounds = true
        
        if event != nil {
            titleText.text = event!.name
            eventDate.text = event!.humanReadableDateString
            eventTime.text = event!.humanReadableTimeRange
            descriptionText.text = event!.eventDescription
            if let tags = event!.tags {
                if tags.count > 0 {
                    eventImage.image = tags[0].getImage()
                } else {
                    eventImage.image = Tag.DEFAULT_TAG_IMAGE
                }
            }

            if event!.isInPast() {
                self.registerButton.isHidden = true
            } else {
                self.registerButton.isHidden = false
                event!.fetchAttendees(successCallback: { (usersAttending) in
                    for attendee in usersAttending {
                        if attendee.objectId == User.current()!.objectId {
                            self.registered = true
                            self.registerButtonBackground.alpha = 0.5
                            break
                        }
                    }
                })
            }

           //Set the map, with the pin. Select the region.
            //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
//            let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
//                                                  MKCoordinateSpanMake(0.1, 0.1))
            
            let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake((event?.location?.latitude)!, (event?.location?.longitude)!),
                                                  MKCoordinateSpanMake(0.01, 0.01))
             mapView.setRegion(sfRegion, animated: false)
            annotateMap()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        if registered {
            self.alreadyRegisteredAlert()
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
        let alertController = UIAlertController(title: "You're Already Registered", message: "You are already registered to volunteer at this event.  Would you like to cancel?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel my registration", style: .default, handler: { (action: UIAlertAction!) in
            self.registered = false
            self.registerButtonBackground.alpha = 1.0
          User.current()!.unregisterEvent(event: self.event!, successCallback: { (unregistered) in
            if unregistered {
                self.createAlert(title: "Unregistered", message: "You successfully unregistered for this event")

                if let delegate = self.delegate {
                    delegate.onUnregister()
                }
            } else {
              self.createAlert(title: "Oops!", message: "Something went wrong. Please try again later or directly contact the organization.")
            }
          })
        }))
        alertController.addAction(UIAlertAction(title: "Stay registered", style: .cancel, handler: { (action: UIAlertAction!) in
            // ok
        }))
        present(alertController, animated: true, completion: nil)
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
    
  // MARK : - MAP Config
    func annotateMap() {
        let annotation = MKPointAnnotation()
        let latitude = event?.location?.latitude as! CLLocationDegrees
        let longitude = event?.location?.longitude as! CLLocationDegrees
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.title = event?.name
        
        mapView.addAnnotation(annotation)
    }
    
    
}

