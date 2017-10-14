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

    class func createNewEventAttendee(user: User, event: Event) -> EventAttendee {
        let newEventAttendee = EventAttendee()
        
        newEventAttendee.setObject(event, forKey: "event")
        newEventAttendee.setObject(user, forKey: "user")
        newEventAttendee.setObject(NSDate(), forKey: "date")
        newEventAttendee.saveInBackground()
        
        return newEventAttendee
    }

    class func getEventsForUser(user: User) -> [Event] {
        let query = PFQuery(className: "EventAttendee")
        query.whereKey("user", equalTo: user)
        var eventAttendees: [EventAttendee] = []
        var events: [Event] = []

        do {
            eventAttendees = try query.findObjects() as! [EventAttendee]
        } catch {
            // unexpected, find nothing
        }
    
        for eventAttendee in eventAttendees {
            let event = eventAttendee.object(forKey: "event")
            
            if let event = event {
                events.append(event as! Event)
            }
        }
        
        return events
    }
}
