//
//  MovieSelected.swift
//  MovieViewer
//
//  Created by Nisarga Patel on 2/7/16.
//  Copyright © 2016 Nisarga Patel. All rights reserved.
//

import UIKit
import AFNetworking
import XCDYouTubeKit

class MovieSelected: UIViewController {
    
    @IBOutlet weak var movieScrollView: UIScrollView!
    var movieInfo : NSDictionary?
    var trailerLinks : [NSDictionary]?
    var trailerLink : String?
    var movieId : Int?
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var trailerBtnRef: UIButton!
    
    @IBOutlet weak var dateInfo: UILabel!
    @IBOutlet weak var ratingInfo: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBAction func trailerBtn(sender: UIButton) {
        
        if self.trailerLinks! != [] {
            //print(self.trailerLinks)
            let key = self.trailerLinks?[0]["key"] as? String
            let site = self.trailerLinks?[0]["site"] as? String
            if site == "YouTube" {
            
                //let baseURL = "https://www.youtube.com/watch?v="
                //let urlString = NSURL(string : baseURL + key!)
                //UIApplication.sharedApplication().openURL(urlString!)
                playVideo(key!)
            
            }
        }
        
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    func playVideo(key : String){
        let videoPlayController = XCDYouTubeVideoPlayerViewController(videoIdentifier: key)
        self.presentMoviePlayerViewControllerAnimated(videoPlayController)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.tabBarController!.tabBar.hidden = true
        self.trailerBtnRef.setImage(UIImage(named: "trailer"), forState: .Normal)
        
        
            
        // Do any additional setup after loading the view.
        /*
        let base = "http://image.tmdb.org/t/p/w500"
        let backdrop = movieInfo!["poster_path"] as? String
        let imageURL = NSURL(string : base  + backdrop!)
        let imageData = NSData(contentsOfURL: imageURL!)
        let backdropImage = UIImage(data: imageData!)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        backdropImage!.drawInRect(self.view.bounds)
        backdropImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: backdropImage!)
*/
        movieScrollView.contentSize = CGSize(width: movieScrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let base = "http://image.tmdb.org/t/p/w500"
        let posterPath = movieInfo!["poster_path"] as? String
        let imageURL = NSURL(string : base  + posterPath!)

        posterImage.setImageWithURL(imageURL!)
        self.navigationItem.title = movieInfo!["title"] as? String
        //let movTitle = movieInfo!["original_title"] as? String
        let release_date = movieInfo!["release_date"] as? String
        let release_arr = release_date!.characters.split{$0 == "-"}.map(String.init)
        
        let year = release_arr[0]
        let month = release_arr[1]
        let day = release_arr[2]
        
            /*
        let release_obj = NSDateComponents()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY"
        let dateObj = dateFormatter.dateFromString(release_date!)
        let dateString = dateFormatter.stringFromDate(dateObj!)
*/
        let rating = movieInfo!["vote_average"] as? Float
        let votes = movieInfo!["vote_count"] as? Int
        let nf_one = NSNumberFormatter()
        let release_obj = NSDateComponents()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY"
        
        release_obj.year = Int(year)!
        release_obj.month = Int(month)!
        
        release_obj.day = Int(day)!
        
        
        let dateObj = NSCalendar.currentCalendar().dateFromComponents(release_obj)
        
        let dateString = dateFormatter.stringFromDate(dateObj!)
        
        let overview = movieInfo!["overview"] as? String
        self.movieId = movieInfo!["id"] as? Int
        getYoutubeLinks(self.movieId!)
        titleLabel.text = movieInfo!["title"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        let nf = NSNumberFormatter()
        
        nf.maximumSignificantDigits = 2
        nf.numberStyle = .DecimalStyle
        dateInfo.text = dateString
        ratingInfo.text = nf.stringFromNumber(rating!)! + "/10 from " + nf_one.stringFromNumber(votes!)! + " votes"
        
        //movieDescriptors.text = "Rating: " + nf.stringFromNumber(rating!)! + "\n" + "Vote Count: " + nf_one.stringFromNumber(votes!)!
        
        //movieDescriptors.text = movieDescriptors.text + "\n" + "Release Date: " + dateString
        
        
    }
    
    func getYoutubeLinks(id : Int){
        // Do any additional setup after loading the view.
        let apiKey = "5dd6c193c804a3a2532bf89d43edefa7"
        let nf = NSNumberFormatter()
        
        //print(self.movieId)
        let baseUrl = "https://api.themoviedb.org/3/movie/"
        
        let url = NSURL(string: baseUrl + (nf.stringFromNumber(self.movieId!))! + "/videos?api_key=\(apiKey)")
        
        // Display HUD right before the request is made
        
        
        
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        // hide the progress bar thing
            let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                
                if((error) != nil){
                    print("There is an error")
                }
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            
                            self.trailerLinks = responseDictionary["results"] as? [NSDictionary]
                            if self.trailerLinks! == [] {
                                self.trailerBtnRef.hidden = true
                            }
                            
                    }
                }
        })
        task.resume()
        
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //loadDataFromNetwork()
        self.navigationController?.navigationBarHidden = false
        
        
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
