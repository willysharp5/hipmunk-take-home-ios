//
//  SearchViewController.swift
//  Hotelzzz
//
//  Created by Steve Johnson on 3/22/17.
//  Copyright © 2017 Hipmunk, Inc. All rights reserved.
//

import Foundation
import WebKit
import UIKit

class SearchViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, SortHotelViewControllerDelegate, FilterHotelViewControllerDelegate {

    struct Search {
        let location: String
        let dateStart: Date
        let dateEnd: Date

        var asJSONString: String {
            return Utils.jsonStringify([
                "location": location,
                "dateStart": Utils.dateFormatter.string(from: dateStart),
                "dateEnd": Utils.dateFormatter.string(from: dateEnd)
            ])
        }
    }
    
    var sortOptionData = ""
    var setFilterData = false
    var priceMaxData = ""
    var priceMinData = ""
    var hotelData = hotelInfo()
    private var _searchToRun: Search?
    

    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect.zero, configuration: {
            let config = WKWebViewConfiguration()
            config.userContentController = {
                let userContentController = WKUserContentController()

                // DECLARE YOUR MESSAGE HANDLERS HERE
                userContentController.add(self, name: "API_READY")
                userContentController.add(self, name: "HOTEL_API_HOTEL_SELECTED")
                userContentController.add(self, name: "HOTEL_API_RESULTS_READY")

                return userContentController
            }()
            return config
        }())
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self

        self.view.addSubview(webView)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", options: [], metrics: nil, views: ["webView": webView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|", options: [], metrics: nil, views: ["webView": webView]))
        return webView
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        webView.reload()
    }
    

    func search(location: String, dateStart: Date, dateEnd: Date) {
        _searchToRun = Search(location: location, dateStart: dateStart, dateEnd: dateEnd)
        self.webView.load(URLRequest(url: URL(string: "http://hipmunk.github.io/hipproblems/ios_hotelapp/")!))
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alertController = UIAlertController(title: NSLocalizedString("Could not load page", comment: ""), message: NSLocalizedString("Looks like the server isn't running.", comment: ""), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Bummer", comment: ""), style: .default, handler: nil))
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "API_READY":
            guard let searchToRun = _searchToRun else { fatalError("Tried to load the page without having a search to run") }
           
            self.webView.evaluateJavaScript(
                "window.JSAPI.runHotelSearch(\(searchToRun.asJSONString))",
                completionHandler: nil)
            
            //run sort
            if sortOptionData != "" {
                sortOptionData = "\u{22}\(sortOptionData)\u{22}" //add quotes
                //print("window.JSAPI.setHotelSort(\(sortOptionData))")
                self.webView.evaluateJavaScript("window.JSAPI.setHotelSort(\(sortOptionData))", completionHandler: nil)
            }
            
            //filter
            if setFilterData {
                priceMaxData = "\u{22}\(priceMaxData)\u{22}" //add quotes
                priceMinData = "\u{22}\(priceMinData)\u{22}" //add quotes
                let setHotelFilter = "window.JSAPI.setHotelFilters({priceMin: \(priceMinData), priceMax: \(priceMaxData)})"
                
                //print(setHotelFilter)
                self.webView.evaluateJavaScript(setHotelFilter, completionHandler: nil)
            }
            
            
        case "HOTEL_API_RESULTS_READY":
            //Update Title to show count
            let json = message.body as! NSDictionary
            let data:NSArray = json.object(forKey: "results") as! NSArray
            
            navigationItem.title = "\(data.count) Records"
            
        case "HOTEL_API_HOTEL_SELECTED":
            //Extract Data
            let json = message.body as! NSDictionary
            hotelData = Utils.cleanUpData(dic: json)
            
            self.performSegue(withIdentifier: "hotel_details", sender: nil)
        default: break
        }
    }
    
    
    
    // MARK: - Sort
    func sortOption(sortOption: String) {
        sortOptionData = sortOption
    }
    
    // MARK: - Filter
    func filterOption(priceMax: String, priceMin: String, setFilter: Bool) {
        setFilterData = setFilter
        priceMinData = priceMin
        priceMaxData = priceMax
    }

}


// MARK: - Navigation
extension SearchViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "hotel_details" {
            let destination = segue.destination as? HotelViewController
            destination?.hotelData = hotelData
        }
        
        if segue.identifier == "select_sort" {
            let navVC = segue.destination as? UINavigationController
            let sortPickerVC = navVC?.topViewController as? SortHotelViewController
            sortPickerVC?.delegate = self
        }
        
        if segue.identifier == "select_filters" {
            let navVC = segue.destination as? UINavigationController
            let filterVC = navVC?.topViewController as? FilterHotelViewController
            filterVC?.delegate = self
        }
        
    }
}
