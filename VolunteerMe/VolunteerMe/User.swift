//
//  User.swift
//  VolunteerMe
//
//  Created by Auster Chen on 10/11/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import Foundation
import Parse

enum UserType: String {
    case Organization = "0"
    case Volunteer = "1"
}

enum UserEventType {
    case All
    case Past
    case Upcoming
}

class User: PFUser {
    static let userTypeToStringMap: [UserType:String] = [
        UserType.Organization: "0",
        UserType.Volunteer: "1",
    ]
    @NSManaged var name: String?
    @NSManaged var userDescription: String?
    @NSManaged var profilePictureUrl: String?
    @NSManaged var userType: String?
    @NSManaged var interests: [Tag]?

    override class func current() -> User? {
        if let user = PFUser.current() {
            if let tags = (user as! User).interests {
                for tag in tags {
                    tag.fetchIfNeededInBackground()
                }
            }
            
            return user as! User
        }

        return nil
    }

    fileprivate class func _createNewUser(username:String, password: String, name: String?, userDescription: String?, userType: UserType?, profilePictureUrl: String?, tags: [Tag]?, successCallback: @escaping (User) -> ()) {
        let user = User()
        user.username = username
        user.password = password

        if let tags = tags {
            user.interests = tags
        }
        
        if let name = name {
            user.name = name
        }
        
        if let userDescription = userDescription {
            user.userDescription = userDescription
        }
        
        if let userType = userType {
            user.userType = userType.rawValue
        } else {
            user.userType = UserType.Volunteer.rawValue
        }
        
        if let profilePictureUrl = profilePictureUrl {
            user.profilePictureUrl = profilePictureUrl
        }
        
        user.signUpInBackground() {
            (success: Bool, error: Error?) in
            if success {
                successCallback(user)
            } else if error != nil {
                print(error!.localizedDescription)
            }
        }
    }

    class func createNewUser(username:String, password: String, name: String?, userDescription: String?, userType: UserType?, profilePictureUrl: String?, tags: [String]?, successCallback: @escaping (User) -> ()) -> () {
        if let tags = tags {
            Tag.getTagsByNameArray(tags) {
                (tags: [Tag]) in
                User._createNewUser(username: username, password: password, name: name, userDescription: userDescription, userType: userType, profilePictureUrl: profilePictureUrl, tags: tags, successCallback: successCallback)
            }
        } else {
            User._createNewUser(username: username, password: password, name: name, userDescription: userDescription, userType: userType, profilePictureUrl: profilePictureUrl, tags: nil, successCallback: successCallback)
        }
    }
    
    class func login(username: String, password: String, successCallback: @escaping (User) -> (), errorCallback: @escaping (Error) -> ()) -> () {
        logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                errorCallback(error)
            } else {
                if let interests = User.current()!.interests {
                    for interest in interests {
                        interest.fetchInBackground()
                    }
                }
                successCallback(user as! User)
            }
            }
    }

    func update(name: String?, userDescription: String?, userType: UserType?, profilePictureUrl: String?, tags: [String]?, successCallback: @escaping (User) -> ()) -> () {
        if let name = name {
            self.name = name
        }

        if let userDescription = userDescription {
            self.userDescription = userDescription
        }

        if let userType = userType {
            self.userType = userType.rawValue
        }

        if let profilePictureUrl = profilePictureUrl {
            self.profilePictureUrl = profilePictureUrl
        }
        
        if let tags = tags {
            let foundTags = Tag.getTagsByNameArraySync(tags)
            let relation = self.relation(forKey: "interests")
            for tag in foundTags {
                relation.add(tag)
            }
        }

        saveInBackground() {
            (success: Bool, error: Error?) in
            if success {
                successCallback(self)
            } else if error != nil {
                print(error!.localizedDescription)
            }
        }
    }

    func getParticipatingEvents(userEventType: UserEventType, successCallback: @escaping ([Event]) -> ()) -> () {
        EventAttendee.getEventsForUser(user: self) {
            (events: [Event]) in
            if userEventType == .All {
                successCallback(events)
            } else if userEventType == .Past {
                let pastEvents = events.filter({ (event: Event) -> Bool in
                    return event.isInPast()
                })
                successCallback(pastEvents)
            } else if userEventType == .Upcoming {
                let upcomingEvents = events.filter({ (event: Event) -> Bool in
                    return event.isInFuture()
                })
                successCallback(upcomingEvents)
            }
        }
    }

    func unregisterEvent(event: Event, successCallback: @escaping (Bool) -> ()) -> () {
        EventAttendee.deleteEventForUser(user: self, event: event, successCallback: successCallback)
    }

    func isUserRegisteredForEvent(event: Event, successCallback: @escaping (Bool) -> ()) -> () {
        return EventAttendee.isUserRegisteredForEvent(user: self, event: event, successCallback: successCallback)
    }

    func isOrganization() -> Bool {
        return userType == UserType.Organization.rawValue
    }

    func isVolunteer() -> Bool {
        return userType == UserType.Volunteer.rawValue
    }

    func printHumanReadableTestString() -> (){
        print("username: \(username)")
        print("userDescription: \(userDescription)")
    }

    func getCompletedEventsHours(successCallback: @escaping (Int) -> ()) -> () {
        EventAttendee.getEventsForUser(user: self) { (events: [Event]) in
            let completedEvents = events.filter({ (event: Event) -> Bool in
                return event.isInPast()
            })
            
            let completedHours = completedEvents.reduce(0, { (result: Int, event: Event) -> Int in
                return result + Int(floor(Double(Int(event.duration!) / 3600)))
            })
            
            successCallback(completedHours)
        }
    }
}
