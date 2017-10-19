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
                print(error?.localizedDescription)
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
    
    class func login(username: String, password: String, successCallback: @escaping (User) -> ()) -> () {
        logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
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
                print(error?.localizedDescription)
            }
        }
    }

    func getParticipatingEvents(userEventType: UserEventType, successCallback: @escaping ([Event]) -> ()) -> () {
        EventAttendee.getEventsForUser(user: self) {
            (events: [Event]) in
            if userEventType == .All {
                successCallback(events)
            } else if userEventType == .Past {
                events.filter({ (event: Event) -> Bool in
                    return event.isInPast()
                })
            } else if userEventType == .Upcoming {
                events.filter({ (event: Event) -> Bool in
                    return event.isInFuture()
                })
            }
        }
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
}
