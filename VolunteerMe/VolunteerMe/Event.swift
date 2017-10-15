//
//  Event.swift
//  VolunteerMe
//
//  Created by Auster Chen on 10/14/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import Foundation
import Parse

class Event:PFObject, PFSubclassing {
    static let DEFAULT_MAX_ATTENDEES = 100
    static let DEFAULT_SEARCH_MILES_RADIUS = 5
    
    @NSManaged var name: String?
    @NSManaged var eventDescription: String?
    @NSManaged var imageUrl: String?
    @NSManaged var location: PFGeoPoint?

    // unix timestamp representing datetime of event
    @NSManaged var datetime: String?
    var maxAttendees: Int?

    class func createEvent(name: String, datetime: String, latLong: (Double, Double), eventDescription: String?, imageUrl: String?, maxAttendees: Int?, successCallback: @escaping (Event) -> ()) -> (){
        let event = Event()
        event.name = name
        event.datetime = datetime
        let (lat, long) = latLong
        event.location = PFGeoPoint(latitude: lat, longitude: long)

        if let eventDescription = eventDescription {
            event.eventDescription = eventDescription
        }

        if let imageUrl = imageUrl {
            event.imageUrl = imageUrl
        }

        if let maxAttendees = maxAttendees {
            event.maxAttendees = maxAttendees
        } else {
            event.maxAttendees = Event.DEFAULT_MAX_ATTENDEES
        }

        event.saveInBackground { (success: Bool, error: Error?) in
            if success {
                successCallback(event)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }

    // Uses current location to find events
    class func findEventsNearby(radiusInMiles: Double, successCallback: @escaping ([Event]) -> ()) -> () {
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint: PFGeoPoint?, error: Error?) in
            if let geoPoint = geoPoint {
                Event.findEventsNearLocation(radiusInMiles: radiusInMiles, targetLocation: (geoPoint.latitude, geoPoint.longitude), successCallback: successCallback)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }

    class func findEventsNearLocation(radiusInMiles: Double, targetLocation: (Double, Double), successCallback: @escaping ([Event]) -> ()) -> () {
        let (lat, long) = targetLocation
        let geoPoint = PFGeoPoint(latitude: lat, longitude: long)
        let query = PFQuery(className: "Event")
        query.whereKey("location", nearGeoPoint: geoPoint, withinMiles: radiusInMiles)
        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            if let results = results {
                let events = results as! [Event]
                successCallback(events)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
    class func parseClassName() -> String {
        return "Event"
    }
}
