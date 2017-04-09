//
//  MapViewController.swift
//  Yelp
//
//  Created by Ekko Lin on 2/20/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate,
BusinessDatasDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    var businesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set initial location
//        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
//        goToLocation(location: centerLocation)
        
        // Set current location
        locationManager = CLLocationManager()
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    
        addResturants(bussinesses: businesses)  // Add resturants
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: true)
        }
        
        // Retrieve updated location
        var locationVal: CLLocationCoordinate2D = (manager.location?.coordinate)!
        print("Locations = \(locationVal.latitude) \(locationVal.longitude)")
    }
    
    
    func didBusinessLoad(business : [Business]?) {
        businesses = business
    }
    
    
    // Customiz annotation as image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"
        
        // custom image annotation
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if (annotationView == nil) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView!.annotation = annotation
        }
        annotationView!.image = UIImage(named: "customAnnotationImage")
        print("hehe")
        
        
        return annotationView
    }
    

    // Add resturants to the map
    func addResturants(bussinesses: [Business]?)
    {
        if let bussinesses = bussinesses
        {
            for business in businesses
            {
                // Add anonotation for all resturants nearby
                mapView.addAnnotationForResturants(address: business.address!, title: business.name!)
                // Add image for annotation
                
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   

}

protocol BusinessDatasDelegate : class {
    func didBusinessLoad(business : [Business]?)
}
