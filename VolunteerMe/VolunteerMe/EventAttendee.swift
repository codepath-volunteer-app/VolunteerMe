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

    class func deleteEventForUser(user: User, event: Event, successCallback: @escaping(Bool) -> ()) -> () {
        let query = PFQuery(className: "EventAttendee")
        query.whereKey("event", equalTo: event)
        query.whereKey("user", equalTo: user)
        
        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            if let results = results {
                if results.count > 0 {
                    let eventAttendee = results[0] as! EventAttendee
                    
                    eventAttendee.deleteInBackground(block: { (success: Bool, error: Error?) in
                        if (success) {
                            successCallback(success)
                        } else if error != nil {
                            print(error?.localizedDescription)
                        }
                    })
                }
            }
        }
    }

    // TODO: account for max attendees
    class func createNewEventAttendee(user: User, event: Event, successCallback: @escaping (Bool) -> ()) -> EventAttendee {
        let newEventAttendee = EventAttendee()

        newEventAttendee.setObject(event, forKey: "event")
        newEventAttendee.setObject(user, forKey: "user")
        newEventAttendee.setObject(NSDate(), forKey: "date")
        newEventAttendee.saveInBackground() {
            (success: Bool, error: Error?) in
            if success {
                successCallback(success)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
        
        return newEventAttendee
    }

    class func getEventsForUser(user: User, successCallback: @escaping ([Event]) -> ()) -> () {
        let query = PFQuery(className: "EventAttendee")
        query.includeKey("event")
        query.whereKey("user", equalTo: user)
        var eventAttendees: [EventAttendee] = []

        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            if let results = results {
                let eventAttendees = results as! [EventAttendee]
                var events: [Event] = []

                for eventAttendee in eventAttendees {
                    let event = eventAttendee.object(forKey: "event")
                    
                    if let event = event {
                        let event = event as! Event
                        event.fetchInBackground()
                        events.append(event)
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
        query.includeKey("user")
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

    class func getUsersForEventSync(_ event: Event) -> [User] {
        let query = PFQuery(className: "EventAttendee")
        query.whereKey("event", equalTo: event)
        var eventAttendees: [EventAttendee] = []
        var users: [User] = []

        do {
            eventAttendees = try query.findObjects() as! [EventAttendee]
        } catch {
            // Print error later
        }

        for eventAttendee in eventAttendees {
            let user = eventAttendee.object(forKey: "user")
            
            if let user = user {
                users.append(user as! User)
            }
        }

        return users
    }

    class func isUserRegisteredForEvent(user: User, event: Event, successCallback: @escaping (Bool) -> () ) -> () {
        let query = PFQuery(className: "EventAttendee")
        query.whereKey("event", equalTo: event)
        query.whereKey("user", equalTo: user)

        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            if let results = results {
                let eventAttendees = results as! [EventAttendee]
                
                successCallback(eventAttendees.count == 1)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
        
    }
}
