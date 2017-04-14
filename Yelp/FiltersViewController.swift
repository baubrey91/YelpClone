
import UIKit
import SevenSwitch

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

enum FilterName: Int {
    case MostPopular = 0, Distance, SortBy, Categories
}

class FiltersViewController: UIViewController {
    
    let prefs = UserDefaults.standard
    
    var currentDistance = ("Auto", -1)
    var currentSort = ("Best Match", 0)
    
    var distanceDictionary = ["Auto" : "-1", "0.3 Miles": "483", "1 Miles" :"1609", "5 Miles" : "8047", "20 Miles" : "32187"]
    
    var filtersArray = [Filter]()
    var switchStates = [IndexPath:AnyObject]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: FiltersViewControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filtersArray.append(Filter(name: "Most Popular", values: [["name" : "Offering A Deal", "code": "0"]], isExpanded: false, expandValue: 1))
        filtersArray.append(Filter(name: "Distance", values: YelpFilters.yelpDistances(), isExpanded: false, expandValue: 1))
        filtersArray.append(Filter(name: "Sort by", values: YelpFilters.yelpSorts(), isExpanded: false, expandValue: 1))
        filtersArray.append(Filter(name: "Categories", values: YelpFilters.yelpCategories(), isExpanded: false, expandValue: 4))
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //switchStates[IndexPath(row: 0, section: 0)] = prefs.bool(forKey: "deal") ?? false
        
        currentDistance.0 = prefs.string(forKey: "radius") ?? "Auto"
        currentDistance.1 = prefs.integer(forKey: "radiusValue") ?? -1
        
        currentSort.0 = prefs.string(forKey: "sort") ?? "Best Match"
        currentSort.1 = prefs.integer(forKey: "sortValue") ?? 0
        
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
        var dealBool:Bool?
        
        for (indexPath,isSelected) in switchStates {
            
            if isSelected.boolValue {
                if indexPath.section == 0 {
                    
                    dealBool = true
                    //prefs.set(dealBool, forKey: "deal")
                }
                if indexPath.section == 3 {
                    selectedCategories.append(filtersArray[indexPath.section].values[indexPath.row]["code"]!)
                }
            }
        }
        if selectedCategories.count > 0 {
            filters["category_filter"] = selectedCategories as AnyObject?
        }
        
        if currentDistance.1 > 0 {
            filters["radius_filter"] = currentDistance.1 as AnyObject
            prefs.set(currentDistance.1, forKey: "radiusValue")
            prefs.set(currentDistance.0, forKey: "radius")


        }
        
        filters["deals_filter"] = dealBool as AnyObject?
        
        filters["sort"] = currentSort.1 as AnyObject
        prefs.set(currentSort.0, forKey: "sort")
        prefs.set(currentSort.1, forKey: "sortValue")
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }
    
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return filtersArray[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filtersArray[section].isExpanded ? filtersArray[section].values.count : filtersArray[section].expandValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentFilter = filtersArray[indexPath.section]
        
        switch indexPath.section {

        case 1,2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxCell") as! CheckBoxCell
            cell.prepareForReuse()


            if (!currentFilter.isExpanded) {
                
                cell.checkLabel.text = ((indexPath.section == 1) ? currentDistance.0 : currentSort.0)
                cell.checkImage.image = #imageLiteral(resourceName: "ExpandArrow")
            } else {
                
                cell.checkLabel.text = currentFilter.values[indexPath.row]["name"]
                if (currentDistance.0 == currentFilter.values[indexPath.row]["name"] ||
                    currentSort.0 == currentFilter.values[indexPath.row]["name"]){
                    
                    cell.checkImage.image = #imageLiteral(resourceName: "Checked")
                } else {
                
                    cell.checkImage.image = #imageLiteral(resourceName: "NotChecked")
                }
            }
            
            return cell

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            cell.prepareForReuse()

            
            cell.delegate = self
            
            if (!currentFilter.isExpanded && indexPath.row == 3) {
                
                cell.switchLabel.text = "More"
                cell.yelpSwitch.isHidden = true
            } else {
                if (indexPath.row == currentFilter.values.count - 1 && currentFilter.expandValue > 1) {
                    cell.yelpSwitch.isHidden = true
                } else {
                    cell.yelpSwitch.on = (switchStates[indexPath] as? Bool) ?? false
                    cell.yelpSwitch.isHidden = false
                }
                cell.switchLabel.text = currentFilter.values[indexPath.row]["name"]
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentFilter = filtersArray[indexPath.section]
        
        if currentFilter.isExpanded {
            switchStates[indexPath] = currentFilter.values[indexPath.row]["code"] as AnyObject
        }
        
        currentFilter.isExpanded = !currentFilter.isExpanded
        tableView.reloadSections(IndexSet([indexPath.section]), with: .automatic)
    }
    
//        switch indexPath.section {
//            
//        case 1, 2:
//            if currentFilter.isExpanded {
//                if indexPath.section == 1 {
//                    currentDistance.0 = currentFilter.values[indexPath.row]["name"]!
//                    currentDistance.1 = Int(currentFilter.values[indexPath.row]["code"]!)!
//                } else {
//                    currentSort.0 = currentFilter.values[indexPath.row]["name"]!
//                    currentSort.1 = Int(currentFilter.values[indexPath.row]["code"]!)!
//                }
//            }
//            
//            currentFilter.isExpanded = !currentFilter.isExpanded
//            tableView.reloadSections(IndexSet([indexPath.section]), with: .automatic)
//        default:
//            if ((indexPath.row == 3 && !currentFilter.isExpanded) || indexPath.row == currentFilter.values.count - 1) {
//                currentFilter.isExpanded = !currentFilter.isExpanded
//                tableView.reloadSections(IndexSet([indexPath.section]), with: .automatic)
//            }
//        }
//    }
//    
//            Filter(name: ("Most Popular", -1), values: [["name" : "Offering A Deal", "code": "0"]], isExpanded: false, expandValue: 1)
//    
//    func setTableViewExpand(indexPath: IndexPath, isExpanded: Bool, expandDistance: Int ){
//        
//        if currentFilter.isExpanded {
//            currentFilter.0 = currentFilter.values.[indexPath.row]["name"]
//            currentFilter.1 = currentFilter.values.[indexPath.row]["code"]
//        }
//        
//        currentFilter.isExpanded = !currentFilter.isExpanded
//        tableView.reloadSections(IndexSet([indexPath.section]), with: .automatic)
//    }
//    
    
    
    
    
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        
        let indexPath = tableView.indexPath(for: switchCell)!
        switchStates[indexPath] = value as AnyObject
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return filtersArray.count
    }
}
