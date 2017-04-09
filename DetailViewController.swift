//
//  DetailViewController.swift
//  Yelp
//
//  Created by Ekko Lin on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController, CLLocationManagerDelegate {

    var responseFieldDictionary: NSDictionary = [:]
    
    @IBOutlet weak var GradeLabel: UILabel!
    @IBOutlet weak var BusinessNameLabel: UILabel!
    @IBOutlet weak var InspectionDateLabel: UILabel!
    @IBOutlet weak var ViolationDescription: UILabel!
    var stringname: String!
    var business: Business!
    var rater: Rater!
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        networkrequest()
        
        BusinessNameLabel.text = business.name
       // GradeLabel.text = rater.grade
       // InspectionDateLabel.text = rater.inspectionDate
       // ViolationDescription.text = rater.violationDescription
        
        // Get my location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        // Add annotation for resturant
        mapView.addAnnotationForCurrentResturant(address: business.address!, title: business.name!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func networkrequest() {
        // Do any additional setup after loading the view.
        let url = URL(string: "http://data.cityofnewyork.us/resource/xx67-kt59.json")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default,delegate:nil,
                                 delegateQueue:OperationQueue.main)
        
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (data, response, error) in
            if let data = data {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    //print("responseDictionary: \(responseDictionary)")
                    
                    // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                    // This is how we get the 'response' field
                    let responseFieldDictionary = responseDictionary.allValues.first as! NSDictionary
                    
                    
                    // This is where you will store the returned array of posts in your posts property
                    //self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                    /*self.posts = responseFieldDictionary["posts"] as? [NSDictionary]
                     self.postsLoaded += self.contentOffset
                     self.loadingMoreView!.stopAnimating()
                     self.tableView.reloadData()*/
                    self.stringname = responseFieldDictionary["cuisine_description"] as? String
                }
            }
            
            
        });
        task.resume()
    }
    
    @IBAction func TakeAPhoto(_ sender: UIButton) {
        self.performSegue(withIdentifier: "takePhoto", sender: self)
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
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "takePhoto" {
            let vc = segue.destination as!  CaptionViewController
            vc.restaurant = self.business.name
            
        }
    }
    

}
