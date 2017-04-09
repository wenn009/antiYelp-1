//
//  Rater.swift
//  Yelp
//
//  Created by Wenn Huang on 4/8/17.
//

import UIKit

class Rater: NSObject {
    let inspectionDate: String?
    let violationDescription: String?
    let grade: String?
    
    init(dictionary: NSDictionary){
        violationDescription = dictionary[""] as? String
        inspectionDate = dictionary[""] as? String
        grade = dictionary[""] as? String
        
    }
    
    class func raters(array: [NSDictionary]) -> [Rater] {
        var raters = [Rater]()
        for dictionary in array {
            let rater = Rater(dictionary: dictionary)
            raters.append(rater)
        }
        return raters
    }
    
    /*class func searchWithTerm(term: String, offset: Int = 0, completion: @escaping ([Business]?, Error?) -> Void) {
        _ = YelpClient.sharedInstance.searchWithTerm(term, offset: offset, completion: completion)
    }
    
    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> Void) -> Void {
        _ = YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, completion: completion)
    }*/

}
