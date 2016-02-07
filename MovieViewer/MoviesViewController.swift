//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Nisarga Patel on 2/1/16.
//  Copyright © 2016 Nisarga Patel. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var navTitleItem: UINavigationItem!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var networkErrorView: UITextView!
    var searchBar : UISearchBar = UISearchBar()
    @IBOutlet weak var tableView: UITableView!
    
    var movies : [NSDictionary]?
    var filteredMovies : [NSDictionary]?
    
    func loadDataFromNetwork(firstTime : Bool = false){
        // Do any additional setup after loading the view.
        let apiKey = "5dd6c193c804a3a2532bf89d43edefa7"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        
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
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                if((error) != nil){
                    print("There is an error")
                    self.networkErrorView.hidden = false
                }
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //print("response: \(responseDictionary)")
                            print("here")
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.filteredMovies = self.movies
                            self.tableView.reloadData()
                            
                    }
                }
        })
        task.resume()

        
    }
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //print("gets here")
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredMovies = movies!.filter({(movObj: NSDictionary) -> Bool in
                // If dataItem matches the searchText, return true to include it
                let movieTitle = movObj["title"] as? String
                if movieTitle!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil{
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadDataFromNetwork()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.sizeToFit()
        navTitleItem.titleView = searchBar
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        loadDataFromNetwork(true)
        
    }
    override func viewDidAppear(animated: Bool) {
        //loadDataFromNetwork()
        self.navigationController?.navigationBarHidden = true

    }
    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredMovies = movies
        tableView.reloadData()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let movies = self.filteredMovies {
            
            return movies.count
        } else {
            
            return 0
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let movie = filteredMovies![indexPath.row]
        performSegueWithIdentifier("GoMovie", sender: movie)
        
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let movie = filteredMovies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        cell.titleLabel.text = title
        let cellBGView = UIView()
        cellBGView.backgroundColor = UIColor(red: 0, green: 0, blue: 200, alpha: 0.4)
        cell.selectedBackgroundView = cellBGView
        
        cell.overviewLabel.text = overview
        
        cell.posterView.setImageWithURL(imageUrl!)
        
        //print("row \(indexPath.row)")
        return cell
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let nextView = segue.destinationViewController as? MovieSelected
        
        let movie = sender as! NSDictionary
        
        nextView!.movieInfo = movie
                
    }


}
