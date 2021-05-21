//
//  InvolveDataModel.swift
//
//  Team Members: Sid Rath (sidrath@iu.edu)
//                Diego Rios-Rojas (dariosro@iu.edu)
//                Shaun Trimm (strimm@iu.edu)
//  Project Name: Involve
//  Final Project Submission Date: May 4, 2021
//

import Foundation
import CoreLocation


class InvolveDataModel {
    var dateFormatter:DateFormatter
    
    var events: [Event]
    var studentOrgs: [StudentOrganization]
    var favoriteEvents: [Event] = []
    var eventsByDate : [String:[Event]] = [String:[Event]]()
    var eventDates: [String] = [String]()
    
    init(){
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "MMMM dd, yyyy, hh:mm a"
        //Initialize Events
        self.events = [
            Event(nameP: "Adobe Photoshop Text Effects Workshop", detailsP: "Join the MediaMakers via Zoom to create fun text effects in Adobe Photoshop!", isFavoriteP: false, timeP: dateFormatter.date(from: "April 24, 2021, 11:00 AM")!, orgP: StudentOrganization(nameP: "IU Center of Excellence for Women & Technology Student Alliance", detailsP: "The IU Center of Excellence for Women & Technology is the nation's first and only large-scale interdisciplinary, university-based initiative to encourage and promote the participation, empowerment, and achievement of women students, faculty, staff, and alumnae in technology."), latitudeP: 39.16752, longitudeP: -86.52370, locationInfoP: "Indiana Memorial Union"),
            Event(nameP: "UB Films presents Judas and the Black Messiah", detailsP: "The longest running college film series continues this Spring with free movies for IU students.", isFavoriteP: false, timeP: dateFormatter.date(from: "April 24, 2021, 6:00 PM")!, orgP: StudentOrganization(nameP: "Student Involvement and Leadership Center", detailsP: "Housed in the Indiana Memorial Union and a key part of the Division of Student Affairs commitment to supporting and enhancing the student experience beyond the classroom, the Student Involvement and Leadership Center is the place for all students at Indiana University to discover ways to connect with the campus, the community, and themselves."), latitudeP: 39.168533, longitudeP: -86.51842, locationInfoP: "IU Auditorium"),
            Event(nameP: "Herman B Wellness Trivia", detailsP: "Ready to show off your IU knowledge? Then come join Union Board on April 27th at 6:00pm on Zoom to participate in our free Herman B Wellness Trivia!", isFavoriteP: false, timeP: dateFormatter.date(from: "April 27, 2021, 6:00 PM")!, orgP: StudentOrganization(nameP: "Student Involvement and Leadership Center", detailsP: "Housed in the Indiana Memorial Union and a key part of the Division of Student Affairs commitment to supporting and enhancing the student experience beyond the classroom, the Student Involvement and Leadership Center is the place for all students at Indiana University to discover ways to connect with the campus, the community, and themselves."), latitudeP: 39.17098, longitudeP: -86.51681, locationInfoP: "Herman B Wells Library"),
            Event(nameP: "Wednesday Night Gathering", detailsP: "Come for a free meal and discussion of various topics in the Bible!", isFavoriteP: false, timeP: dateFormatter.date(from: "May 05, 2021, 7:30 PM")!, orgP: StudentOrganization(nameP: "Jubilee", detailsP: "Jubilee is a supportive and accepting Christ-centered community for students and young adults of all backgrounds. We aspire to share God's unconditional love with everyone, serve joyfully, and challenge one another in faith. We have Wednesday gatherings at 7:30pm with in-person and virtual options: some meet at First United Methodist Church, while others join virtually. Join us for dinner, discussion, and worship, and/or join us throughout the week for small groups, service projects, and various events."), latitudeP: 39.16600119889491, longitudeP: -86.53160811543657, locationInfoP: "First United Methodist Church of Bloomington")
        ]
        
        self.studentOrgs = []
        //for all events add the student org to the set of student orgs
        for x in self.events {
            if(self.studentOrgs.count == 0){
                self.studentOrgs.append(x.org)
            }
            else{
                var notInOrgs = true
                for y in self.studentOrgs {
                    if(y.name == x.org.name && y.details == x.org.details){
                        notInOrgs = false
                        break
                    }
                }
                if (notInOrgs == true) {
                    self.studentOrgs.append(x.org)
                }
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        for event in self.events {
            let dateKey = dateFormatter.string(from: event.time)
            
            if self.eventsByDate[dateKey] != nil {
                self.eventsByDate[dateKey]!.append(event)
            } else {
                self.eventsByDate[dateKey] = [event]
            }
        }
        
        for (date, _) in self.eventsByDate {
            self.eventDates.append(date)
            
        }

        let sortedDates = self.eventDates.sorted {dateFormatter.date(from: $0)! < dateFormatter.date(from: $1)!}
        self.eventDates = sortedDates
    }
    
    func addFavoriteEvent(name: String, details: String, time: Date, org: StudentOrganization, latitude: Double, longitude: Double, locationInfo: String) {
        self.favoriteEvents.append(Event(nameP: name, detailsP: details, isFavoriteP: true, timeP: time, orgP: org, latitudeP: latitude, longitudeP: longitude, locationInfoP: locationInfo))
    }
    
}

class Event : NSObject, Codable {
    var name: String  //Stores the name of the event
    var details: String //Stores event details
    var isFavorite: Bool //Stores the favorite status of an event
    var time: Date //Stores date and time of the event
    var org: StudentOrganization
    var latitude: Double
    var longitude: Double
    var locationInfo: String
    
    override var description: String {
        return self.name + " " + self.details + " \(self.isFavorite) " + " \(self.time) " + " \(latitude) " + " \(longitude) "
    }
    
    init(nameP:String, detailsP:String, isFavoriteP:Bool, timeP:Date, orgP:StudentOrganization, latitudeP:Double, longitudeP: Double, locationInfoP: String) {
        self.name = nameP
        self.details = detailsP
        self.isFavorite = isFavoriteP
        self.time = timeP
        self.org = orgP
        self.latitude = latitudeP
        self.longitude = longitudeP
        self.locationInfo = locationInfoP
    }
}

class StudentOrganization : NSObject, Codable {
    var name: String
    var details: String
    //var orgEvents: [Event]
    override var description: String {
        return self.name + " " + self.details //+  " \(orgEvents)"
    }
    
    init(nameP:String, detailsP:String) { //, orgEventsP:[Event]
        self.name = nameP
        self.details = detailsP
    }
    
}
