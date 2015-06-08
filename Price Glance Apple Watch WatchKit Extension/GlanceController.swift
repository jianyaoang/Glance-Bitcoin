//
//  GlanceController.swift
//  Price Glance Apple Watch WatchKit Extension
//
//  Created by VLT Labs on 6/8/15.
//  Copyright (c) 2015 Jay Ang. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {

    @IBOutlet weak var bitcoinPriceLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        let bitcoinURL = NSURL(string: "https://api.bitcoinaverage.com/all")!
        let bitcoinURLRequest = NSURLRequest(URL: bitcoinURL)
        
        NSURLConnection.sendAsynchronousRequest(bitcoinURLRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            let allDataDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! [String: AnyObject]
            let USD = allDataDictionary["USD"] as! [String:AnyObject]
            let USDAverage = USD["averages"] as! [String:AnyObject]
            let latestUSDBitcoinPrice = USDAverage["last"] as! Float
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.bitcoinPriceLabel.setText("$\(latestUSDBitcoinPrice)")
            })
        }
    }

    override func willActivate() {
        super.willActivate()
        
        self.bitcoinPriceLabel.setText("Fetching latest price..")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    

}
