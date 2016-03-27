//
//  ViewController.swift
//  Bullet
//
//  Created by Jordan Lu on 3/26/16.
//  Copyright © 2016 Jordan Lu. All rights reserved.
//

import UIKit

class TrendingViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var popupDisplayed = false
    var currentOverlay : PopupView!
    var allEvents = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = colorWithHexString("ebebeb")
        collectionView.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        let urlPath: String = "http://ec2-54-164-108-53.compute-1.amazonaws.com:3000/api/events"
        allEvents = getJSON(urlPath)
        
        self.collectionView.reloadData()
    }
    
    func getJSON(urlToRequest: String) -> NSArray {
        let data = NSData(contentsOfURL: NSURL(string: urlToRequest)!)        
        let response = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSArray
        
        return response
    }
    
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return allEvents.count
    }
    
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("bottomCells", forIndexPath:indexPath) as! CollectionViewCell
        
        guard let event = allEvents[indexPath.item] as? NSDictionary,
            let title = event["name"] as? String,
            let url = event["photo_url"] as? String
        else {
            return cell
        }
        
        if let label = cell.titleLabel {
            label.text = title
        }
        
        if let imageView = cell.imageView {
            getDataFromUrl(NSURL(string: url)!) { (data, response, error)  in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    guard let data = data where error == nil else { return }
                    imageView.image = UIImage(data: data)
                }
            }
        }
        
        return cell
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: -10, left: 10, bottom: 10, right: 10)
    }
    
    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if (indexPath.item == 0) {
            return CGSize(width: collectionView.frame.size.width - 20, height: 250)
        } else {
            return CGSize(width: (collectionView.frame.size.width - 25) / 2, height: (collectionView.frame.size.width - 25) / 2)
        }
    }

    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 5
    }
    
    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 5
    }
    
    internal func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let event = allEvents[indexPath.item] as? NSDictionary,
        let title = event["name"] as? String,
        let url = event["photo_url"] as? String,
        let date = event["date"] as? String,
        let location = event["location"] as? String
        else {
            print("fail")
            return
        }
        print(title)
        print(url)
        if (!popupDisplayed) {
            let overlayView = PopupView()
            overlayView.frame = CGRectMake(18,15, 340, 600)
            overlayView.backgroundColor = UIColor.whiteColor()
            overlayView.alpha = CGFloat(0.9)
            if let label = overlayView.titleLabel {
                label.text = title
            }
            if let dateText = overlayView.dateLabel {
                dateText.text = date
            }
            if let locationText = overlayView.locationLabel {
                locationText.text = location
            }
            self.view.addSubview(overlayView)
            currentOverlay = overlayView
            popupDisplayed = true
        } else {
            if (currentOverlay != nil) {
                currentOverlay.removeFromSuperview()
                popupDisplayed = false
            }
        }
    }
}

