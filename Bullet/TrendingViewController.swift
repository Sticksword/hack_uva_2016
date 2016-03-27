//
//  ViewController.swift
//  Bullet
//
//  Created by Jordan Lu on 3/26/16.
//  Copyright © 2016 Jordan Lu. All rights reserved.
//

import UIKit

class TrendingViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CollectionViewCellDelegate, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var detailsView: DetailsView!
    var popupDisplayed = false
    var allEvents = []
    var toggleState = 1
    
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
        
        cell.delegate = self
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CollectionViewCell().showHeart(_:)))
//        tapGesture.numberOfTapsRequired = 2
//        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    func cellButtonTapped(cell: CollectionViewCell) {
        let indexPath = self.collectionView.indexPathForCell(cell)
        if cell.toggleState == 1 {
            cell.toggleState = 2
            
            let id = (allEvents[indexPath!.item] as? NSDictionary)!["_id"] as? String
            let url = "http://ec2-54-164-108-53.compute-1.amazonaws.com:3000/api/events/" + id!

            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional
            request.HTTPMethod = "PUT"
            
            let numLikes = ((allEvents[indexPath!.item] as? NSDictionary)!["interested"] as! Int) + 1
            let toAdd = "interested=" + String(numLikes)
            
            let session = NSURLSession(configuration:NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: nil)
            
            let data = toAdd.dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPBody = data
            
            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if error != nil {
                    
                    //handle error
                }
                else {
                    print("Success")
                } 
            }
            
            task.resume()
            
            cell.likeButton.setImage(UIImage(named: "Love"), forState: UIControlState.Normal)
        } else {
            cell.toggleState = 1
            
            let id = (allEvents[indexPath!.item] as? NSDictionary)!["_id"] as? String
            let url = "http://ec2-54-164-108-53.compute-1.amazonaws.com:3000/api/events/" + id!
            
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional
            request.HTTPMethod = "PUT"
            
            let numLikes = ((allEvents[indexPath!.item] as? NSDictionary)!["interested"] as! Int) - 1
            let toAdd = "interested=" + String(numLikes)
            
            let session = NSURLSession(configuration:NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: nil)
            
            let data = toAdd.dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPBody = data
            
            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if error != nil {
                    
                    //handle error
                }
                else {
                    print("Success")
                }
            }
            
            task.resume()

            
            cell.likeButton.setImage(UIImage(named: "Heart"), forState: UIControlState.Normal)
        }
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
    
    @IBAction func sortByLikes(sender: AnyObject) {
        if allEvents.count > 1 {
            allEvents = allEvents.sort {
                return (($0 as? NSDictionary)!["interested"]! as! Int) > (($1 as? NSDictionary)!["interested"]! as! Int)
            }
            
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func sortByTime(sender: AnyObject) {
        if allEvents.count > 1 {
            allEvents = allEvents.sort {
                return (($0 as? NSDictionary)!["date"]! as! String) < (($1 as? NSDictionary)!["date"]! as! String)
            }
                        
            self.collectionView.reloadData()
        }
    }

    
    internal func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let event = allEvents[indexPath.item] as? NSDictionary,
            let title = event["name"] as? String,
            let date = event["date"] as? String,
            let location = event["location"] as? String,
            let aDescription = event["description"] as? String
        else {
            print("fail")
            return
        }
        if (!popupDisplayed) {
            self.detailsView.alpha = CGFloat(1.0)
            self.collectionView.alpha = CGFloat(0.9)
            
            if let label = self.detailsView.titleLabel {
                label.text = title
                print(title)
            }
            if let dateText = self.detailsView.date {
                dateText.text = date
            }
            if let locationText = self.detailsView.location {
                locationText.text = location
            }
            
            if let descriptionText = self.detailsView.eventDescription {
                descriptionText.text = aDescription
            }
            
            self.detailsView.image.image = (self.collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell).imageView.image!
            
            popupDisplayed = true
        } else {
            self.collectionView.alpha = 1.0
            self.detailsView.alpha = 0.0
            popupDisplayed = false
        }
    }
}

