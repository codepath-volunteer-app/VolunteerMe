//
//  Event.swift
//  VolunteerMe
//
//  Created by Auster Chen on 10/14/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import Foundation
import Parse
import DateToolsSwift

class Event:PFObject, PFSubclassing {
    fileprivate static let DEFAULT_MAX_ATTENDEES = 100
    fileprivate static let DEFAULT_SEARCH_MILES_RADIUS = 5
    fileprivate static let DEFAULT_NUMBER_OF_ITEMS_TO_SEARCH = 20
    
    @NSManaged var name: String?
    @NSManaged var nameLower: String?
    @NSManaged var eventDescription: String?
    @NSManaged var eventDescriptionLower: String?
    @NSManaged var imageUrl: String?
    @NSManaged var location: PFGeoPoint?
    @NSManaged var tags: [Tag]?
    // unix timestamp representing datetime of event
    @NSManaged var datetime: String?
    @NSManaged var maxAttendees: NSNumber?

    var humanReadableDateString: String? {
        get {
            if let datetime = datetime {
                let date = Date(timeIntervalSince1970: Double(datetime)!)
                
                return date.format(with: .long)
            }
            
            return nil
        }
    }
    var attendees: [User] = []

    fileprivate class func _getEvents(radiusInMiles: Double, targetLocation: (Double, Double), searchString: String?, tags: [Tag]?, limit: Int?, successCallback: @escaping ([Event]) -> ()) -> () {
        let (lat, long) = targetLocation
        let geoPoint = PFGeoPoint(latitude: lat, longitude: long)
        let query = PFQuery(className: "Event")
        query.includeKey("tags")
        query.whereKey("location", nearGeoPoint: geoPoint, withinMiles: radiusInMiles)
        
        if let tags = tags {
            if tags.count > 0 {
                query.whereKey("tags", containsAllObjectsIn: tags)
            }
        }
        
        if let searchString = searchString {
            query.whereKey("nameLower", hasPrefix: searchString.lowercased())
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

    fileprivate class func _createEvent(name: String, datetime: String, latLong: (Double, Double), eventDescription: String?, imageUrl: String?, maxAttendees: Int?, tags: [Tag]?, successCallback: @escaping (Event) -> ()) -> (){
        let event = Event()
        event.name = name
        event.nameLower = name.lowercased()
        event.datetime = datetime
        let (lat, long) = latLong
        event.location = PFGeoPoint(latitude: lat, longitude: long)
        
        if let eventDescription = eventDescription {
            event.eventDescription = eventDescription
            event.eventDescriptionLower = eventDescription.lowercased()
        }
        
        if let imageUrl = imageUrl {
            event.imageUrl = imageUrl
        }
    
        if let tags = tags {
            event.tags = tags
        }
        
        if let maxAttendees = maxAttendees {
            event.maxAttendees = NSNumber(value: maxAttendees)
        } else {
            event.maxAttendees = NSNumber(value: Event.DEFAULT_MAX_ATTENDEES)
        }
        
        event.saveInBackground { (success: Bool, error: Error?) in
            if success {
                successCallback(event)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }

    class func createEvent(name: String, datetime: String, latLong: (Double, Double), eventDescription: String?, imageUrl: String?, maxAttendees: Int?, tags: [String]?, successCallback: @escaping (Event) -> ()) -> (){
        if let tags = tags {
            Tag.getTagsByNameArray(tags) {
                (tags: [Tag]) in
                Event._createEvent(name: name, datetime: datetime, latLong: latLong, eventDescription: eventDescription, imageUrl: imageUrl, maxAttendees: maxAttendees, tags: tags, successCallback: successCallback)
            }
        } else {
            Event._createEvent(name: name, datetime: datetime, latLong: latLong, eventDescription: eventDescription, imageUrl: imageUrl, maxAttendees: maxAttendees, tags: nil, successCallback: successCallback)
        }
    }

    // Uses current location to find events
    class func getNearbyEvents(radiusInMiles: Double, searchString: String?, tags: [String]?, limit: Int?, successCallback: @escaping ([Event]) -> ()) -> () {
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint: PFGeoPoint?, error: Error?) in
            if let geoPoint = geoPoint {
                Event.getEvents(radiusInMiles: radiusInMiles, targetLocation: (geoPoint.latitude, geoPoint.longitude), searchString: searchString, tags: tags, limit: limit, successCallback: successCallback)
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }

    class func getEvents(radiusInMiles: Double, targetLocation: (Double, Double), searchString: String?, tags: [String]?, limit: Int?, successCallback: @escaping ([Event]) -> ()) -> () {
        if let tags = tags {
            Tag.getTagsByNameArray(tags) {
                (tags: [Tag]) in
                Event._getEvents(radiusInMiles: radiusInMiles, targetLocation: targetLocation, searchString: searchString, tags: tags, limit: limit, successCallback: successCallback)
            }
        } else {
            Event._getEvents(radiusInMiles: radiusInMiles, targetLocation: targetLocation, searchString: searchString, tags: nil, limit: limit, successCallback: successCallback)
        }
    }

    func isInPast() -> Bool {
        let date: Date = Date(timeIntervalSince1970: Double(datetime!)!)
    
        return date.isEarlier(than: .init(timeIntervalSinceNow: 0))
    }

    func isInFuture() -> Bool {
        let date: Date = Date(timeIntervalSince1970: Double(datetime!)!)
        
        return date.isLater(than: .init(timeIntervalSinceNow: 0))
    }
    
    class func parseClassName() -> String {
        return "Event"
    }

    func getTags(successCallback: @escaping ([Tag]) -> ()) -> () {
        PFQuery(className: "Event").includeKey("tags").whereKey("objectId", equalTo: objectId!).findObjectsInBackground() {
            (results: [PFObject]?, error: Error?) in
            if let results = results {
                if results.count > 0 {
                    let event = results[0] as! Event
                    successCallback(event.tags ?? [])
                }
            } else if error != nil {
                print(error?.localizedDescription)
            }
        }
    }

    func getRemainingSpots() -> Int {
        if let maxAttendees = maxAttendees {
            return Int(maxAttendees) - attendees.count
        } else {
            return Event.DEFAULT_MAX_ATTENDEES - attendees.count
        }
    }

    func registerUser(user: User, successCallback: @escaping (Bool) -> ()) -> () {
        EventAttendee.createNewEventAttendee(user: user, event: self, successCallback: successCallback)
    }

    func fetchAttendees(successCallback: @escaping ([User]) -> ()) {
        EventAttendee.getUsersForEvent(event: self) {
            (users: [User]) in
            self.attendees = users
            successCallback(users)
        }
    }

    func isUserRegisteredForEvent(user: User, successCallback: @escaping (Bool) -> ()) -> () {
        return EventAttendee.isUserRegisteredForEvent(user: user, event: self, successCallback: successCallback)
    }

    func printHumanReadableTestString() -> () {
        
        print("event name: \(name)")
        print("event description: \(eventDescription)")
        print("event time: \(humanReadableDateString)")
        print("event url: \(imageUrl)")
        print("event location: lat: \(location!.latitude), long: \(location!.longitude)")
    }
}
