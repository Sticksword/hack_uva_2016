//
//  ViewController.swift
//  Bullet
//
//  Created by Jordan Lu on 3/26/16.
//  Copyright © 2016 Jordan Lu. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitView: UIView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    let categories = ["Food", "Music", "Sports", "Arts", "Cultural", "Educational"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PostViewController.imageTapped(_:)))
        imageView.addGestureRecognizer(tapGesture)
        
        textView.text = "Description"
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textView.textColor = UIColor.lightGrayColor()
        textView.layer.cornerRadius = 5
        
        let backgroundGesture = UITapGestureRecognizer(target: self, action: #selector(PostViewController.backgroundTapped(_:)))
        self.view.addGestureRecognizer(backgroundGesture)
        
        let submitGesture = UITapGestureRecognizer(target: self, action: #selector(PostViewController.submitTapped(_:)))
        self.submitView.addGestureRecognizer(submitGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backgroundTapped(gesture: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func imageTapped(gesture: UIGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func submitTapped(gesture: UIGestureRecognizer) {
//        let url = NSURL(string: "http://ec2-54-164-108-53.compute-1.amazonaws.com:3000/api/events")
        var link = ""
        
        let image = imageView.image!
        let base64String = UIImageJPEGRepresentation(image, 1.0)!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    
        let clientId = "Client-ID f34fe8516f05db6"
            
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.imgur.com/3/upload")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = base64String.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue(clientId, forHTTPHeaderField: "Authorization")
        
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                dispatch_async(dispatch_get_main_queue(), {
                    if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                    }
                    
                    do {
                        let myData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                        link = ((myData["data"] as! NSDictionary)["link"]) as! String
                        
                        self.finishPost(link)
                    } catch {
                        print("ERROR")
                    }
                    
                })
            }
        
            task.resume()
    }
    
    func finishPost(url: String) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let date = dateFormatter.stringFromDate(self.datePicker.date)
        
        var descriptionText = ""
        if self.textView.text == "Description" {
            descriptionText = ""
        } else {
            descriptionText = self.textView.text
        }
        
        let object = ["name":self.titleTextField.text!, "location":self.locationTextField.text!, "description":descriptionText, "date":date, "photo_url":url, "category":self.categoryPickerView.selectedRowInComponent(0)]
                
        let request = NSMutableURLRequest(URL: NSURL(string: "http://ec2-54-164-108-53.compute-1.amazonaws.com:3000/api/events")!)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(object, options: [])
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            dispatch_async(dispatch_get_main_queue(), {
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                do {                    
                    let alert = UIAlertController(title: "Success!", message: "You have successfully shared your event!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {_ in self.textView.text = ""
                        self.titleTextField.text = ""
                        self.locationTextField.text = ""
                        self.datePicker.date = NSDate()
                        self.imageView.image = UIImage(named: "Camera")
                        
                        self.tabBarController?.selectedIndex = 1
                    }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            })
        }
        
        task.resume()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.blackColor()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return categories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }

}

