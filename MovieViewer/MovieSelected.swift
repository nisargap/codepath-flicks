//
//  MovieSelected.swift
//  MovieViewer
//
//  Created by Nisarga Patel on 2/7/16.
//  Copyright © 2016 Nisarga Patel. All rights reserved.
//

import UIKit

class MovieSelected: UIViewController {

    var movieInfo : NSDictionary?
    
    @IBOutlet weak var movieDescriptors: UITextView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var summaryText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
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
        let base = "http://image.tmdb.org/t/p/w500"
        let posterPath = movieInfo!["poster_path"] as? String
        let imageURL = NSURL(string : base  + posterPath!)

        posterImage.setImageWithURL(imageURL!)
        self.navigationItem.title = movieInfo!["title"] as? String
        let movTitle = movieInfo!["original_title"] as? String
        let rating = movieInfo!["vote_average"] as? Float
        let overview = movieInfo!["overview"] as? String
        summaryText.text = overview
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        movieDescriptors.text = movTitle! + "\n" + "Rating: " + nf.stringFromNumber(rating!)!
        
        
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
