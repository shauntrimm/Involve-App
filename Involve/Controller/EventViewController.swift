//
//  EventViewController.swift
//
//  Team Members: Sid Rath (sidrath@iu.edu)
//                Diego Rios-Rojas (dariosro@iu.edu)
//                Shaun Trimm (strimm@iu.edu)
//  Project Name: Involve
//  Final Project Submission Date: May 4, 2021
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications

class EventViewController: UIViewController {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventHost: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    var eventNameFromTable: String = ""
    var eventHostFromTable: StudentOrganization!
    var eventDateFromTable: Date!
    var eventDetailsFromTable: String = ""
    
    var long: Double = 0.0
    var lat: Double = 0.0
    var locInfo: String = ""
    
    @IBAction func addToFavorites(_ sender: Any) {
        let lAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let lInvolveDataModel = lAppDelegate.involveModel
        
        var inFavorites: Bool = true
        
        if(lInvolveDataModel.favoriteEvents.count == 0) {
            lInvolveDataModel.addFavoriteEvent(name: self.eventNameFromTable,
                                               details: self.eventDetailsFromTable,
                                               time: self.eventDateFromTable,
                                               org: self.eventHostFromTable,
                                               latitude: lat,
                                                longitude: long,
                                                locationInfo: locInfo)
        } else {
            for event in lInvolveDataModel.favoriteEvents {
                if event.name == self.eventNameFromTable && event.details == self.eventDetailsFromTable {
                    inFavorites = true
                    break
                } else {
                    inFavorites = false
                }
            }
            
            if(inFavorites == true) {
                showAlert()
            } else {
                lInvolveDataModel.addFavoriteEvent(name: self.eventNameFromTable,
                                                   details: self.eventDetailsFromTable,
                                                   time: self.eventDateFromTable,
                                                   org: self.eventHostFromTable,
                                                   latitude: lat,
                                                    longitude: long,
                                                    locationInfo: locInfo)

            }
        }
        

        //write to a .plist file
        let fav = lInvolveDataModel.favoriteEvents
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            print(docsurl)
            let favFile = docsurl.appendingPathComponent("favoriteEvents.plist")
            let plister = PropertyListEncoder()
            plister.outputFormat = .xml
            try plister.encode(fav).write(to: favFile, options: .atomic)
//            let s = try String.init(contentsOf: favFile)
//            print(s)
        } catch {
        }
        
        //create notification content
        let content = UNMutableNotificationContent()
        content.title = "You have an event in 30 minutes!"
        content.subtitle = self.eventNameFromTable
        content.body = locInfo
        content.sound = UNNotificationSound.default
        
        //create notification trigger
        //60 seconds times 30
        let date = self.eventDateFromTable.addingTimeInterval(-(60 * 30))
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        //notification will appear 10 seconds after button is pressed
        //use for testing
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        //create notification request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        //register notification request
        UNUserNotificationCenter.current().add(request) { (error) in
            //handle any errors
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Event Already Added", message: "You Have Already Added This Event To Your Favorites", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        timeFormatter.dateFormat = "h:mm a"
    
        
        self.eventName.text = self.eventNameFromTable
        self.eventHost.text = self.eventHostFromTable.name
        self.eventDate.text = dateFormatter.string(from: self.eventDateFromTable)
        self.eventTime.text = timeFormatter.string(from: self.eventDateFromTable)
        
        
        //Build the map view
        let lAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let lInvolveDataModel = lAppDelegate.involveModel
        //Get the longitude and latitude from the corresponding event in the list of events
        for x in lInvolveDataModel.events {
            if(x.name == self.eventNameFromTable && x.details == self.eventDetailsFromTable){
                long = x.longitude
                lat = x.latitude
                locInfo = x.locationInfo
                break
            }
        }
        
        var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
        var placemark: MKPointAnnotation = MKPointAnnotation()
        placemark.coordinate = location
        placemark.title = locInfo
        var region: MKCoordinateRegion = MKCoordinateRegion()
        region.center.latitude = lat
        region.center.longitude = long
        region.span.latitudeDelta = 0.005
        region.span.longitudeDelta = 0.005
        
        mapView.setRegion(region, animated: true)
        //mapView.setCenter(location, animated: true)
        mapView.addAnnotation(placemark)
        // Do any additional setup after loading the view.
    }

    
}

