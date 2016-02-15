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
class MoviesViewController: UIViewController,UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var navTitleItem: UINavigationItem!
    
    
    @IBAction func networkErrorAct(sender: UIButton) {
        loadDataFromNetwork(true)
        moviesCollectionView.reloadData()
    }
    @IBOutlet weak var networkErrorBtn: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    var searchBar : UISearchBar = UISearchBar()
    
    var movies : [NSDictionary]?
    var filteredMovies : [NSDictionary]?
    var endpoint : String!
    
    func loadDataFromNetwork(firstTime : Bool = false){
        // Do any additional setup after loading the view.
        let apiKey = "5dd6c193c804a3a2532bf89d43edefa7"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        
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
        if(firstTime == true){
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "Loading"
        }
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if(firstTime == true){
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                }
                if((error) != nil){
                    print("There is an error")
                    self.networkErrorBtn.hidden = false
                }
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //print("response: \(responseDictionary)")
                            self.networkErrorBtn.hidden = true
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.filteredMovies = self.movies
                            self.moviesCollectionView.reloadData()
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
            filteredMovies = movies?.filter({(movObj: NSDictionary) -> Bool in
                // If dataItem matches the searchText, return true to include it
                let movieTitle = movObj["title"] as? String
                if movieTitle!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil{
                    return true
                } else {
                    return false
                }
            })
            
        }
        moviesCollectionView.reloadData()
    }
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadDataFromNetwork()
        refreshControl.endRefreshing()
        moviesCollectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        moviesCollectionView.alwaysBounceVertical = true
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchBar.barTintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        let searchFieldText = searchBar.valueForKey("searchField") as? UITextField
        
        searchFieldText!.textColor = UIColor(red: 1.0, green: 224/255, blue: 25/255, alpha: 1.0)
        
        
        navTitleItem.titleView = searchBar
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        moviesCollectionView.addSubview(refreshControl)
        loadDataFromNetwork(true)
        self.navigationController?.navigationBarHidden = true

        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //loadDataFromNetwork()
        self.navigationController?.navigationBarHidden = true
        self.tabBarController!.tabBar.hidden = false
        


    }
    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        moviesCollectionView.reloadData()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredMovies = movies
        moviesCollectionView.reloadData()
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = self.filteredMovies {
            
            return movies.count
        } else {
            
            return 0
        }

    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
         let cell = moviesCollectionView.dequeueReusableCellWithReuseIdentifier("com.nisarga.MovieCell", forIndexPath: indexPath) as! MovieCollectionCell
        
        let movie = filteredMovies![indexPath.row]
        let posterPath = movie["poster_path"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        cell.moviePoster.setImageWithURL(imageUrl!)
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let movie = filteredMovies![indexPath.row]
        performSegueWithIdentifier("GoMovie", sender: movie)
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
