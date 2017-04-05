
import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

@objc protocol FiltersViewDelegate {
    @objc func onFiltersDone(controller: FiltersViewController)
}

class FiltersViewController: UIViewController {
    
    let sectionTitlesArray = ["", "Distance", "Sort By", "Category"]
    let featuredArray = ["Offering a Deal"]
    let distanceArray = ["Auto", "0.3 Miles", "1 Miles", "5 Miles", "20 Miles"]
    let sortBy = ["Best Match","Distance","Rating","Most Reviewed"]
    
    var switchStates = [IndexPath:Bool]()
    var categoriesArray = [[String:String]]()
    var distanceExpanded = false
    var sortByExpanded = false
    var categoryExapanded = false
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: FiltersViewDelegate?
    
    var model: SearchFilters?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model = SearchFilters(instance: SearchFilters.instance)
        
        categoriesArray = YelpFilters.yelpCategories()
        /*let categoryNames = categories.map { $0["name"]! }
        filtersBySection = [("Most Popular", ["Offering a Deal"]),
                                ("Distance", ["Best Match", "0.3 miles", "1 mile", "5 miles", "20 miles"]),
                                ("Sort by", ["Best Match", "Distance", "Rating", "Most Reviewed"]),
                                ("Categories", categoryNames)]*/
        
        tableView.reloadData()

        //categories = yelpCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func Search(_ sender: Any) {
        SearchFilters.instance.copyStateFrom(instance: self.model!)

        dismiss(animated: true, completion: nil)
        self.delegate?.onFiltersDone(controller: self)

        /*var filters = [String: AnyObject]()
        
        var selectedCategories = [String]()
        for (row,isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject?
        }
        
        print(filters)
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)*/
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
            return sortByExpanded ? sortBy.count : 1
        default:
            return categoryExapanded ? categoriesArray.count : 4
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
        cell.delegate = self
        
        switch indexPath.section {
        case 0:
            cell.switchLabel.text = featuredArray[indexPath.row]
            cell.onSwitch.isOn = switchStates[indexPath] ?? false
        case 1:
            cell.switchLabel.text = distanceArray[indexPath.row]
            cell.onSwitch.isHidden = true

        case 2:
            cell.switchLabel.text = sortBy[indexPath.row]
            cell.onSwitch.isHidden = true

        case 3:
            if (!categoryExapanded && indexPath.row == 3) {
                cell.switchLabel.text = "More"
                //cell.onSwitch.isHidden = true
            } else {
                cell.switchLabel.text = categoriesArray[indexPath.row]["name"]
                cell.onSwitch.isOn = switchStates[indexPath] ?? false
            }
        default :
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            return
        case 1:
           // if (distanceExpanded) {
                distanceExpanded = !distanceExpanded
                tableView.reloadData()
            //}
        case 2:
          //  if (sortByExpanded) {
                sortByExpanded = !sortByExpanded
                tableView.reloadData()
           // }
        default:
            if ((indexPath.row == 3 && !categoryExapanded) || indexPath.row == categoriesArray.count - 1) {
                categoryExapanded = !categoryExapanded
                tableView.reloadData()
            }
        }
    }
    
      /*  let filter = self.model!.filters[indexPath.section]
        switch filter.type {
        case .Single:
            if (filter.opened) {
                let previousIndex = filter.selectedIndex
                if previousIndex != indexPath.row {
                    filter.selectedIndex = indexPath.row
                    let previousIndexPath = NSIndexPath(row: previousIndex, section: indexPath.section)
                    self.tableView.reloadRows(at: [indexPath, previousIndexPath as IndexPath], with: .automatic)
                }
            }
            
            let opened = filter.opened;
            filter.opened = !opened;
            
            if opened {
//                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC)))
//                dispatch_after(time, dispatch_get_main_queue(), {
                self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
                //})
            } else {
                self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
            }
        case .Multiple:
            if !(filter.opened) && indexPath.row == filter.numItemsVisible {
                filter.opened = true
                self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
            } else {
                let option = filter.options[indexPath.row]
                option.selected = !(option.selected)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }*/
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        
        let indexPath = tableView.indexPath(for: switchCell)!
        switchStates[indexPath] = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionTitlesArray.count
    }
}
