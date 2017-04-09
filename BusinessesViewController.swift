//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import SwiftyJSON

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    var businesses: [Business]!
    var raters: [Rater]!
    @IBOutlet var tableView: UITableView!
    var searchBar: UISearchBar!
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Settings for table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Initialize a UIRefreshControl
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)

        
        // Settings for search bar
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets

        
        Business.searchWithTerm(term: "", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                    print(business.zipCode!)
                    print(business.categories!)
                }
            }
        }
        )
        retrieveData();
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        }else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell;
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // ... Code to load more results ...
                loadMoreData()
            }
        }
    }
    
    
    // loading more data from infinite scroll
    func loadMoreData()
    {
        Business.searchWithTerm(term: "", offset: (self.businesses?.count)!)
        {
            (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses?.append(contentsOf: businesses!)
            self.loadingMoreView!.stopAnimating()
            self.isMoreDataLoading = false
            self.tableView.reloadData()
        }
    }
    
    
    // Refresh Controll Action
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        loadMoreData()
        // Reload the tableView now that there is new data
        self.tableView.reloadData()
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Search bar functions
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        Business.searchWithTerm(term: searchBar.text!, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            self.tableView.reloadData()
        }
        )
    }
    
    
    // Retrieve data from NYU Json report
    private func retrieveData() {
        // Get data
        if let path = Bundle.main.path(forResource: "sfDataSet", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObject = JSON(data: data)
                if jsonObject != JSON.null {
                    print("jsonData: \(jsonObject)")
                    print("Json file retrieved")
                } else {
                    print("Could not get json from file, make sure that file contains valid json.")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
       // if let sender = sender as? BusinessCell {
        if segue.identifier == "detailsSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for:cell)
            let business = businesses![indexPath!.row]
            //let rater = self.raters![indexPath!.row]
            let vc = segue.destination as! DetailViewController
            vc.business = business
           // vc.rater = rater
        } else if let sender = sender as? UIBarButtonItem {
            if sender.image! == UIImage(named: "map")! {
                let mapVC = segue.destination as! MapViewController
                // Send data
                mapVC.businesses = self.businesses
            }
        }
     }
    
    
}
