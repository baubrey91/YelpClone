
import UIKit
import SevenSwitch

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController {

    
    let sectionTitlesArray = ["", "Distance", "Sort By", "Category"]
    let featuredArray = ["Offering a Deal"]
//    let distanceArray = ["Auto", "0.3 Miles" , "1 Miles" , "5 Miles", "20 Miles"]
    var distanceArray = [[String:String]]()

    let sortByArray = ["Best Match" , "Distance", "Highest Rating"]
    let sortByValue: [YelpSortMode] = [.bestMatched, .distance, .highestRated]
    
    //var currentSort = "Best Match"
    var currentDistance = "Auto"
    var currentDistanceValue = -1
    var currentSort : YelpSortMode = .bestMatched

    
    var categories : [[String:String]]!
    var switchStates = [IndexPath:Bool]()
    var categoriesArray = [[String:String]]()
    var distanceExpanded = false
    var sortByExpanded = false
    var categoryExapanded = false
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: FiltersViewControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        categoriesArray = YelpFilters.yelpCategories()
        distanceArray = YelpFilters.yelpDistance()
        /*let categoryNames = categories.map { $0["name"]! }
        filtersBySection = [("Most Popular", ["Offering a Deal"]),
                                ("Distance", ["Best Match", "0.3 miles", "1 mile", "5 miles", "20 miles"]),
                                ("Sort by", ["Best Match", "Distance", "Rating", "Most Reviewed"]),
                                ("Categories", categoryNames)]*/
        
        tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func Search(_ sender: Any) {

        dismiss(animated: true, completion: nil)

        var filters = [String: AnyObject]()
        var selectedCategories = [String]()
        var dealBool = false
        
        for (indexPath,isSelected) in switchStates {
            if isSelected {
                if indexPath.section == 0 {
                    dealBool = true
                }
                if indexPath.section == 3 {
                selectedCategories.append(categoriesArray[indexPath.row]["code"]!)
                }
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject?
        }
        
        filters["radiusFilter"] = currentDistanceValue as AnyObject?
        print(currentDistanceValue)
        filters["deals"] = dealBool as AnyObject?
        filters["sort"] = currentSort as AnyObject?
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }
    
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitlesArray[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return featuredArray.count
        case 1:
            return distanceExpanded ? distanceArray.count : 1
        case 2:
            return sortByExpanded ? sortByArray.count : 1
        default:
            return categoryExapanded ? categoriesArray.count : 4
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            cell.delegate = self

            cell.switchLabel.text = featuredArray[indexPath.row]
            cell.yelpSwitch.on = switchStates[indexPath] ?? false
            cell.yelpSwitch.isHidden = false
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxCell") as! CheckBoxCell

            //cell.delegate = self
            if (!distanceExpanded) {
                
                cell.checkLabel.text = currentDistance
                cell.checkImage.image = #imageLiteral(resourceName: "ExpandArrow")
            } else {
                
                cell.checkLabel.text = distanceArray[indexPath.row]["distance"]
                if currentDistance == distanceArray[indexPath.row]["distance"] {
                    
                    cell.checkImage.image = #imageLiteral(resourceName: "Checked")
                } else {
                    
                    cell.checkImage.image = #imageLiteral(resourceName: "NotChecked")
                }
            }
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxCell") as! CheckBoxCell

            if (!sortByExpanded) {
                
                cell.checkLabel.text = sortByArray[currentSort.rawValue]
                cell.checkImage.image = #imageLiteral(resourceName: "ExpandArrow")
            } else {
                
                cell.checkLabel.text = sortByArray[indexPath.row]
                if currentSort.rawValue == indexPath.row {
                    
                    cell.checkImage.image = #imageLiteral(resourceName: "Checked")
                } else {
                    
                    cell.checkImage.image = #imageLiteral(resourceName: "NotChecked")
                }
            }
            
            return cell

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            
            cell.delegate = self
            if (!categoryExapanded && indexPath.row == 3) {
                
                cell.switchLabel.text = "More"
                cell.yelpSwitch.isHidden = true
            } else {
                
                cell.switchLabel.text = categoriesArray[indexPath.row]["name"]
                cell.yelpSwitch.on = switchStates[indexPath] ?? false
                cell.yelpSwitch.isHidden = false

            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.section {
        case 0:
            return
        case 1:
            if (distanceExpanded) {
                
                currentDistance = distanceArray[indexPath.row]["distance"]!
                currentDistanceValue = Int(distanceArray[indexPath.row]["meters"]!)!
            }
            distanceExpanded = !distanceExpanded
            tableView.reloadSections(IndexSet([indexPath.section]), with: .automatic)

        case 2:
            if (sortByExpanded) {
 
                currentSort = sortByValue[indexPath.row]
            }
        
            sortByExpanded = !sortByExpanded
            tableView.reloadSections(IndexSet([indexPath.section]), with: .automatic)

        default:
            if ((indexPath.row == 3 && !categoryExapanded) || indexPath.row == categoriesArray.count - 1) {
                categoryExapanded = !categoryExapanded
                tableView.reloadSections(IndexSet([indexPath.section]), with: .automatic)
            }
        }
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        
        let indexPath = tableView.indexPath(for: switchCell)!
        switchStates[indexPath] = value
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionTitlesArray.count
    }
}
