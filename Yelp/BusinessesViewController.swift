import UIKit

class BusinessesViewController: UIViewController, FiltersViewControllerDelegate {
    
    var searchBar: UISearchBar!
    
    var refreshControl: UIRefreshControl!
    var labelsArray: Array<UILabel> = []
    var isAnimating = false
    var currentColorIndex = 0
    var currentLabelIndex = 0
    var customView: UIView!
    var timer: Timer!
    
    var currentSearch = "Thai"
    var limit = 10
    var offSet = 0
    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?

    var businesses: [Business]!
    
    var filters = [String: AnyObject]()

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filters["category_filter"] = nil
        filters["sort"] = YelpSortMode.bestMatched.rawValue as AnyObject
        filters["deals_filter"] = 0 as AnyObject
        filters["radius_filter"] = 4000 as AnyObject
        filters["offset"] = 0 as AnyObject
        filters["term"] = currentSearch as AnyObject
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        //set up custom pull to refresh animation
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.clear
        tableView.addSubview(refreshControl)
        loadCustomRefreshContents()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        Business.searchWithTerm(filter: filters,term: currentSearch, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
            
        })
        
        func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            offSet = 10
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            if !isAnimating {
                refreshData()
                animateRefreshStepOne()
            }
        }
    }
    
    
    func loadCustomRefreshContents() {
        let refreshContents = Bundle.main.loadNibNamed("RefreshContents", owner: self, options: nil)
        
        customView = refreshContents?[0] as! UIView
        customView.frame = refreshControl.bounds
        
        for i in 0..<customView.subviews.count {
            labelsArray.append(customView.viewWithTag(i + 1) as! UILabel)
        }
        
        refreshControl.addSubview(customView)
    }
    
    func animateRefreshStepOne() {
        isAnimating = true
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            self.labelsArray[self.currentLabelIndex].transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
            self.labelsArray[self.currentLabelIndex].textColor = ((self.currentLabelIndex % 2 == 0) ? UIColor.red : UIColor.white)
            
        }, completion: { (finished) -> Void in
            
            UIView.animate(withDuration: 0.05, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                self.labelsArray[self.currentLabelIndex].transform = CGAffineTransform.identity
                self.labelsArray[self.currentLabelIndex].textColor = UIColor.black
                
            }, completion: { (finished) -> Void in
                self.currentLabelIndex += 1
                
                if self.currentLabelIndex < self.labelsArray.count {
                    self.animateRefreshStepOne()
                }
                else {
                    self.animateRefreshStepTwo()
                }
            })
        })
    }
    
    
    func animateRefreshStepTwo() {
        UIView.animate(withDuration: 0.35, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            for i in 0..<7 {
                
                self.labelsArray[i].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            
        }, completion: { (finished) -> Void in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                for i in 0..<7 {
                    self.labelsArray[i].transform = CGAffineTransform.identity
                }
                
            }, completion: { (finished) -> Void in
                if self.refreshControl.isRefreshing {
                    self.currentLabelIndex = 0
                    self.animateRefreshStepOne()
                }
                else {
                    self.isAnimating = false
                    self.currentLabelIndex = 0
                    for i in 0 ..< self.labelsArray.count {
                        self.labelsArray[i].textColor = UIColor.black
                        self.labelsArray[i].transform = CGAffineTransform.identity
                    }
                }
            })
        })
    }
    
    func refreshData() {
        timer = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(BusinessesViewController.endOfWork), userInfo: nil, repeats: true)
        
/*        In an effort to fully display the custom pulldown animation I added a timer. To actually refesh data uncomment code below and comment out timer + endOfWork function
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
            self.endOfWork()
        })*/
    }
    
    func endOfWork() {
        refreshControl.endRefreshing()
        
        timer.invalidate()
        timer = nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterSegue"{
        
            let navigationController = segue.destination as! UINavigationController
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            filtersViewController.delegate = self
        }
        else if segue.identifier == "mapSegue"{
            
            if let vc = segue.destination as? MapCollectionViewController {
                vc.businesses = businesses
            }
        }
        else if segue.identifier == "detailSegue"{
            
            if let vc = segue.destination as? DetailViewController {
                let indexPath = tableView.indexPath(for: sender as! BusinessCell)!
                vc.business = businesses[indexPath.row]
            }
        }
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {

        print(filters)
        //filters?["term"] = "Thai"
        
        Business.searchWithTerm(filter: filters,
                                term: currentSearch) {
                                    (businesses: [Business]?, error: Error?) -> Void in
                                    self.businesses = businesses
                                    self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// SearchBar methods
extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        offSet = 0
        currentSearch = searchBar.text!
        filters["term"] = searchBar.text! as AnyObject?
        filters["offset"] = offSet as AnyObject
        
        searchBar.resignFirstResponder()
        Business.searchWithTerm(filter: filters, term: currentSearch, completion: { (businesses: [Business]?, error: Error?) -> Void in
            if businesses != nil {
                self.businesses = businesses
                self.tableView.reloadData()
            } else {
                print("no data")
            }
        })
    }
}

extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
}

extension BusinessesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        offSet += 10
        filters["offset"] = offSet as AnyObject

        Business.searchWithTerm(filter: self.filters,
                                term: currentSearch) {
                                    (businesses: [Business]?, error: Error?) -> Void in
                                    self.isMoreDataLoading = false
                                    self.loadingMoreView!.stopAnimating()
                                    self.businesses! += businesses!
                                    self.tableView.reloadData()
        }
    }
}
