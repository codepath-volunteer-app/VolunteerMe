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
    static let DEFAULT_NUMBER_OF_ITEMS_TO_SEARCH = 20
    
    @NSManaged var name: String?
    @NSManaged var eventDescription: String?
    @NSManaged var imageUrl: String?
    @NSManaged var location: PFGeoPoint?

    // unix timestamp representing datetime of event
    @NSManaged var datetime: String?
    var maxAttendees: Int = Event.DEFAULT_MAX_ATTENDEES
    var tags: [Tag] {
        get {
            do {
                let tags = try self.relation(forKey: "tags").query().findObjects()
                
                return tags as! [Tag]
            } catch {
                return []
            }
        }
    }
    var attendees: [User] {
        get {
            return EventAttendee.getUsersForEventSync(self)
        }
    }

    class func createEvent(name: String, datetime: String, latLong: (Double, Double), eventDescription: String?, imageUrl: String?, maxAttendees: Int?, tags: [String]?, successCallback: @escaping (Event) -> ()) -> (){
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

        if let tags = tags {
            let foundTags = Tag.findTagsByNameArraySync(tags)
            let relation = event.relation(forKey: "tags")
            for tag in foundTags {
                relation.add(tag)
            }
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
    class func queryNearbyEvents(radiusInMiles: Double, searchString: String?, tags: [Tag]?, limit: Int?, successCallback: @escaping ([Event]) -> ()) -> () {
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint: PFGeoPoint?, error: Error?) in
            if let geoPoint = geoPoint {
                Event.queryEvents(radiusInMiles: radiusInMiles, targetLocation: (geoPoint.latitude, geoPoint.longitude), searchString: searchString, tags: tags, limit: limit, successCallback: successCallback)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }

    class func queryEvents(radiusInMiles: Double, targetLocation: (Double, Double), searchString: String?, tags: [Tag]?, limit: Int?, successCallback: @escaping ([Event]) -> ()) -> () {
        let (lat, long) = targetLocation
        let geoPoint = PFGeoPoint(latitude: lat, longitude: long)
        let query = PFQuery(className: "Event")
        query.whereKey("location", nearGeoPoint: geoPoint, withinMiles: radiusInMiles)

        if let tags = tags {
            query.whereKey("tags", containsAllObjectsIn: tags)
        }

        if let searchString = searchString {
            query.whereKey("name", hasPrefix: searchString)
        }
        
        if let limit = limit {
            query.limit = limit
        } else {
            query.limit = Event.DEFAULT_NUMBER_OF_ITEMS_TO_SEARCH
        }

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

    func getRemainingSpots() -> Int {
        return Event.DEFAULT_MAX_ATTENDEES - attendees.count
    }

    func isUserRegisteredForEvent(user: User, successCallback: @escaping (Bool) -> ()) -> () {
        return EventAttendee.isUserRegisteredForEvent(user: user, event: self, successCallback: successCallback)
    }
}
