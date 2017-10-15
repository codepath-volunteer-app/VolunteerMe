//
//  EventAttendee.swift
//  VolunteerMe
//
//  Created by Auster Chen on 10/14/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import Foundation
import Parse

class EventAttendee: PFObject, PFSubclassing {
    var user: User?
    var event: Event?
    var date: NSDate?

    class func parseClassName() -> String {
        return "EventAttendee"
    }

    // TODO: account for max attendees
    class func createNewEventAttendee(user: User, event: Event) -> EventAttendee {
        let newEventAttendee = EventAttendee()
        
        newEventAttendee.setObject(event, forKey: "event")
        newEventAttendee.setObject(user, forKey: "user")
        newEventAttendee.setObject(NSDate(), forKey: "date")
        newEventAttendee.saveInBackground()
        
        return newEventAttendee
    }

    class func getEventsForUser(user: User, successCallback: @escaping ([Event]) -> ()) -> () {
        let query = PFQuery(className: "EventAttendee")
        query.whereKey("user", equalTo: user)
        var eventAttendees: [EventAttendee] = []

        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            if let results = results {
                let eventAttendees = results as! [EventAttendee]
                var events: [Event] = []

                for eventAttendee in eventAttendees {
                    let event = eventAttendee.object(forKey: "event")
                    
                    if let event = event {
                        events.append(event as! Event)
                    }
                }

                successCallback(events)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }

    class func getUsersForEvent(event: Event, successCallback: @escaping ([User]) -> ()) -> () {
        let query = PFQuery(className: "EventAttendee")
        query.whereKey("event", equalTo: event)
        var eventAttendees: [EventAttendee] = []
        
        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            if let results = results {
                let eventAttendees = results as! [EventAttendee]
                var users: [User] = []
                
                for eventAttendee in eventAttendees {
                    let user = eventAttendee.object(forKey: "user")
                    
                    if let user = user {
                        users.append(user as! User)
                    }
                }
                
                successCallback(users)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
}
