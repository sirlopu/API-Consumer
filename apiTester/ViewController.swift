//
//  ViewController.swift
//  apiTester
//  Test application to send GET, POST, PUT, PATCH, DELETE requests to endpoints
//
//  Tested with Swift 3.0
//
//  Created by Gabriel on 11/7/16.
//  Copyright © 2016 sirlopu. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    //URL for NutritionIX API: https://api.nutritionix.com/v1_1/search
    let url: URL = URL(string: "https://api.nutritionix.com/v1_1/search")!
    
    //NutritionIX API Developer AppId and Key
    let kAppId = "3ba28368"
    let kAppKey = "cf7831818e3f250e1cebe17b056429d9"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.autocorrectionType = .default
        searchBar.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        do {
            try makeRequest(searchString: searchBar.text!)
        }
        catch {
            print (error.localizedDescription)
        }
        searchBar.text = ""        
    }
    
    func makeRequest (searchString: String) throws {
        
        let request: Request = Request()
        
        let params = [
            "appId" : kAppId,
            "appKey" : kAppKey,
            "fields" : ["item_name", "brand_name", "nf_serving_size_qty", "nf_serving_size_unit", "keywords", "usda_fields"],
            "limit"  : "5",
            "query"  : searchString,
            "filters": ["exists":["usda_fields": true]]] as [String : Any]
        
        try request.post(url: url, body: params, completionHandler: { data, response, error in
            guard let _:Data = data, let _:URLResponse = response , error == nil else { return }

            do {

                let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary
                print(jsonDictionary!)
                
            }
            catch {
                
                print(error.localizedDescription)
                let errorString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Error in Parsing \(errorString)")
                
            }
        })
    }
}

