//
//  mapViewExtension.swift
//  Yelp
//
//  Created by Ekko Lin on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit
import MapKit


extension MKMapView
{
    func addAnnotationForCurrentResturant(address: String, title name: String = "")
    {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address)
        {
            (placemarks, error) -> Void in
            
            if let placemark = placemarks?.first
            {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = name
                
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinates, span)
                self.setRegion(region, animated: false)
                self.addAnnotation(annotation)
            }
        }
    }
    
    func addAnnotationForResturants(address: String, title name: String = "")
    {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address)
        {
            (placemarks, error) -> Void in
            
            if let placemark = placemarks?.first
            {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = name
                
                self.addAnnotation(annotation)
            }
        }
    }
}
