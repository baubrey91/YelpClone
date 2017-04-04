
import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

@objc protocol FiltersViewDelegate {
    @objc func onFiltersDone(controller: FiltersViewController)
}

class FiltersViewController: UIViewController {
    
    //category, sort (best match, distance, highest rated), distance, deals (on/off).

//    let categories = ["String": "String"]
//    let categoryNames = categories.map { $0["name"]! }
//    var filtersBySection = [("Most Popular", ["Offering a Deal"]),
//    ("Distance", ["Best Match", "2 blocks", "6 blocks", "1 mile", "5 miles"]),
//    ("Sort by", ["Best Match", "Distance", "Raiting", "Most Reviewed"]),
//    ("Categories", categoryNames)]

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: FiltersViewDelegate?

    //weak var delegate: FiltersViewControllerDelegate?
    
    var model: SearchFilters?
    
   /* var categories : [[String:String]]!
    var switchStates = [Int:Bool]()
    var filtersBySection = [(String, [String])]()*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model = SearchFilters(instance: SearchFilters.instance)
        
       /* let categories = self.yelpCategories()
        let categoryNames = categories.map { $0["name"]! }
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
    
    func yelpCategories() -> [[String:String]] {
        return   [["name" : "Afghan", "code": "afghani"],
                  ["name" : "African", "code": "african"],
                  ["name" : "American, New", "code": "newamerican"],
                  ["name" : "American, Traditional", "code": "tradamerican"],
                  ["name" : "Arabian", "code": "arabian"],
                  ["name" : "Argentine", "code": "argentine"],
                  ["name" : "Armenian", "code": "armenian"],
                  ["name" : "Asian Fusion", "code": "asianfusion"],
                  ["name" : "Asturian", "code": "asturian"],
                  ["name" : "Australian", "code": "australian"],
                  ["name" : "Austrian", "code": "austrian"],
                  ["name" : "Baguettes", "code": "baguettes"],
                  ["name" : "Bangladeshi", "code": "bangladeshi"],
                  ["name" : "Barbeque", "code": "bbq"],
                  ["name" : "Basque", "code": "basque"],
                  ["name" : "Bavarian", "code": "bavarian"],
                  ["name" : "Beer Garden", "code": "beergarden"],
                  ["name" : "Beer Hall", "code": "beerhall"],
                  ["name" : "Beisl", "code": "beisl"],
                  ["name" : "Belgian", "code": "belgian"],
                  ["name" : "Bistros", "code": "bistros"],
                  ["name" : "Black Sea", "code": "blacksea"],
                  ["name" : "Brasseries", "code": "brasseries"],
                  ["name" : "Brazilian", "code": "brazilian"],
                  ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                  ["name" : "British", "code": "british"],
                  ["name" : "Buffets", "code": "buffets"],
                  ["name" : "Bulgarian", "code": "bulgarian"],
                  ["name" : "Burgers", "code": "burgers"],
                  ["name" : "Burmese", "code": "burmese"],
                  ["name" : "Cafes", "code": "cafes"],
                  ["name" : "Cafeteria", "code": "cafeteria"],
                  ["name" : "Cajun/Creole", "code": "cajun"],
                  ["name" : "Cambodian", "code": "cambodian"],
                  ["name" : "Canadian", "code": "New)"],
                  ["name" : "Canteen", "code": "canteen"],
                  ["name" : "Caribbean", "code": "caribbean"],
                  ["name" : "Catalan", "code": "catalan"],
                  ["name" : "Chech", "code": "chech"],
                  ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                  ["name" : "Chicken Shop", "code": "chickenshop"],
                  ["name" : "Chicken Wings", "code": "chicken_wings"],
                  ["name" : "Chilean", "code": "chilean"],
                  ["name" : "Chinese", "code": "chinese"],
                  ["name" : "Comfort Food", "code": "comfortfood"],
                  ["name" : "Corsican", "code": "corsican"],
                  ["name" : "Creperies", "code": "creperies"],
                  ["name" : "Cuban", "code": "cuban"],
                  ["name" : "Curry Sausage", "code": "currysausage"],
                  ["name" : "Cypriot", "code": "cypriot"],
                  ["name" : "Czech", "code": "czech"],
                  ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                  ["name" : "Danish", "code": "danish"],
                  ["name" : "Delis", "code": "delis"],
                  ["name" : "Diners", "code": "diners"],
                  ["name" : "Dumplings", "code": "dumplings"],
                  ["name" : "Eastern European", "code": "eastern_european"],
                  ["name" : "Ethiopian", "code": "ethiopian"],
                  ["name" : "Fast Food", "code": "hotdogs"],
                  ["name" : "Filipino", "code": "filipino"],
                  ["name" : "Fish & Chips", "code": "fishnchips"],
                  ["name" : "Fondue", "code": "fondue"],
                  ["name" : "Food Court", "code": "food_court"],
                  ["name" : "Food Stands", "code": "foodstands"],
                  ["name" : "French", "code": "french"],
                  ["name" : "French Southwest", "code": "sud_ouest"],
                  ["name" : "Galician", "code": "galician"],
                  ["name" : "Gastropubs", "code": "gastropubs"],
                  ["name" : "Georgian", "code": "georgian"],
                  ["name" : "German", "code": "german"],
                  ["name" : "Giblets", "code": "giblets"],
                  ["name" : "Gluten-Free", "code": "gluten_free"],
                  ["name" : "Greek", "code": "greek"],
                  ["name" : "Halal", "code": "halal"],
                  ["name" : "Hawaiian", "code": "hawaiian"],
                  ["name" : "Heuriger", "code": "heuriger"],
                  ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                  ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                  ["name" : "Hot Dogs", "code": "hotdog"],
                  ["name" : "Hot Pot", "code": "hotpot"],
                  ["name" : "Hungarian", "code": "hungarian"],
                  ["name" : "Iberian", "code": "iberian"],
                  ["name" : "Indian", "code": "indpak"],
                  ["name" : "Indonesian", "code": "indonesian"],
                  ["name" : "International", "code": "international"],
                  ["name" : "Irish", "code": "irish"],
                  ["name" : "Island Pub", "code": "island_pub"],
                  ["name" : "Israeli", "code": "israeli"],
                  ["name" : "Italian", "code": "italian"],
                  ["name" : "Japanese", "code": "japanese"],
                  ["name" : "Jewish", "code": "jewish"],
                  ["name" : "Kebab", "code": "kebab"],
                  ["name" : "Korean", "code": "korean"],
                  ["name" : "Kosher", "code": "kosher"],
                  ["name" : "Kurdish", "code": "kurdish"],
                  ["name" : "Laos", "code": "laos"],
                  ["name" : "Laotian", "code": "laotian"],
                  ["name" : "Latin American", "code": "latin"],
                  ["name" : "Live/Raw Food", "code": "raw_food"],
                  ["name" : "Lyonnais", "code": "lyonnais"],
                  ["name" : "Malaysian", "code": "malaysian"],
                  ["name" : "Meatballs", "code": "meatballs"],
                  ["name" : "Mediterranean", "code": "mediterranean"],
                  ["name" : "Mexican", "code": "mexican"],
                  ["name" : "Middle Eastern", "code": "mideastern"],
                  ["name" : "Milk Bars", "code": "milkbars"],
                  ["name" : "Modern Australian", "code": "modern_australian"],
                  ["name" : "Modern European", "code": "modern_european"],
                  ["name" : "Mongolian", "code": "mongolian"],
                  ["name" : "Moroccan", "code": "moroccan"],
                  ["name" : "New Zealand", "code": "newzealand"],
                  ["name" : "Night Food", "code": "nightfood"],
                  ["name" : "Norcinerie", "code": "norcinerie"],
                  ["name" : "Open Sandwiches", "code": "opensandwiches"],
                  ["name" : "Oriental", "code": "oriental"],
                  ["name" : "Pakistani", "code": "pakistani"],
                  ["name" : "Parent Cafes", "code": "eltern_cafes"],
                  ["name" : "Parma", "code": "parma"],
                  ["name" : "Persian/Iranian", "code": "persian"],
                  ["name" : "Peruvian", "code": "peruvian"],
                  ["name" : "Pita", "code": "pita"],
                  ["name" : "Pizza", "code": "pizza"],
                  ["name" : "Polish", "code": "polish"],
                  ["name" : "Portuguese", "code": "portuguese"],
                  ["name" : "Potatoes", "code": "potatoes"],
                  ["name" : "Poutineries", "code": "poutineries"],
                  ["name" : "Pub Food", "code": "pubfood"],
                  ["name" : "Rice", "code": "riceshop"],
                  ["name" : "Romanian", "code": "romanian"],
                  ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                  ["name" : "Rumanian", "code": "rumanian"],
                  ["name" : "Russian", "code": "russian"],
                  ["name" : "Salad", "code": "salad"],
                  ["name" : "Sandwiches", "code": "sandwiches"],
                  ["name" : "Scandinavian", "code": "scandinavian"],
                  ["name" : "Scottish", "code": "scottish"],
                  ["name" : "Seafood", "code": "seafood"],
                  ["name" : "Serbo Croatian", "code": "serbocroatian"],
                  ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                  ["name" : "Singaporean", "code": "singaporean"],
                  ["name" : "Slovakian", "code": "slovakian"],
                  ["name" : "Soul Food", "code": "soulfood"],
                  ["name" : "Soup", "code": "soup"],
                  ["name" : "Southern", "code": "southern"],
                  ["name" : "Spanish", "code": "spanish"],
                  ["name" : "Steakhouses", "code": "steak"],
                  ["name" : "Sushi Bars", "code": "sushi"],
                  ["name" : "Swabian", "code": "swabian"],
                  ["name" : "Swedish", "code": "swedish"],
                  ["name" : "Swiss Food", "code": "swissfood"],
                  ["name" : "Tabernas", "code": "tabernas"],
                  ["name" : "Taiwanese", "code": "taiwanese"],
                  ["name" : "Tapas Bars", "code": "tapas"],
                  ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                  ["name" : "Tex-Mex", "code": "tex-mex"],
                  ["name" : "Thai", "code": "thai"],
                  ["name" : "Traditional Norwegian", "code": "norwegian"],
                  ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                  ["name" : "Trattorie", "code": "trattorie"],
                  ["name" : "Turkish", "code": "turkish"],
                  ["name" : "Ukrainian", "code": "ukrainian"],
                  ["name" : "Uzbek", "code": "uzbek"],
                  ["name" : "Vegan", "code": "vegan"],
                  ["name" : "Vegetarian", "code": "vegetarian"],
                  ["name" : "Venison", "code": "venison"],
                  ["name" : "Vietnamese", "code": "vietnamese"],
                  ["name" : "Wok", "code": "wok"],
                  ["name" : "Wraps", "code": "wraps"],
                  ["name" : "Yugoslav", "code": "yugoslav"]]
    }
    
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let filter = self.model?.filters[section]
        let label = filter?.label
        
        if filter?.type == .Multiple && (filter?.numItemsVisible!)! > 0 && (filter?.numItemsVisible!)! < (filter?.options.count)! && !(filter?.opened)! {
            let selectedOptions = filter?.selectedOptions
            return "\(label) (\(selectedOptions?.count) selected)"
        }
        
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filter = (self.model?.filters[section])! as Filter
        if !filter.opened {
            if filter.type == FilterType.Single {
                return 1
            } else if filter.numItemsVisible! > 0 && filter.numItemsVisible! < filter.options.count {
                return filter.numItemsVisible! + 1
            }
        }
        return filter.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "SwitchCell") as! 
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
        cell.delegate = self

        
        let filter = (self.model?.filters[indexPath.section])! as Filter
        switch filter.type {
        case .Single:
            if filter.opened {
                let option = filter.options[indexPath.row]
                cell.switchLabel?.text = option.label
                if option.selected {
                    cell.onSwitch.isOn = true } else { cell.onSwitch.isOn = false
                    /*
                    cell.accessoryView = UIImageView(image: UIImage(named: "Check"))
                } else {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Uncheck"))*/
                }
            } else {
                cell.switchLabel?.text = filter.options[filter.selectedIndex].label
                //cell.accessoryView = UIImageView(image: UIImage(named: "Dropdown"))
            }
        case .Multiple:
            if filter.opened || indexPath.row < filter.numItemsVisible! {
                let option = filter.options[indexPath.row]
                cell.switchLabel?.text = option.label
                if option.selected {
                    cell.onSwitch.isOn = true } else { cell.onSwitch.isOn = false
                    /*
                    cell.accessoryView = UIImageView(image: UIImage(named: "Check"))
                } else {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Uncheck"))*/
                }
            } else {
                cell.switchLabel?.text = "See All"
                cell.onSwitch.isHidden = true
                //cell.textLabel?.textAlignment = NSTextAlignment.center
                //cell.textLabel?.textColor = .darkGray
            }
        default:
            let option = filter.options[indexPath.row]
            cell.switchLabel?.text = option.label
            /*cell.selectionStyle = UITableViewCellSelectionStyle.none
            let switchView = UISwitch(frame: CGRect.zero)
            switchView.isOn = option.selected
            switchView.onTintColor = UIColor(red: 73.0/255.0, green: 134.0/255.0, blue: 231.0/255.0, alpha: 1.0)
            switchView.addTarget(self, action: "handleSwitchValueChanged:", for: UIControlEvents.valueChanged)
            cell.accessoryView = switchView*/
        }
        
        return cell
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
//        //cell.switchLabel.text = categories[indexPath.row]["name"]
//        cell.switchLabel.text = self.filtersBySection[indexPath.section].1[indexPath.row]
//
//        cell.delegate = self
//        
//        cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
//        
//        return cell
    }
    
    func handleSwitchValueChanged(switchView: UISwitch) -> Void {
        let cell = switchView.superview as! UITableViewCell
        if let indexPath = self.tableView.indexPath(for: cell) {
            let filter = (self.model?.filters[indexPath.section])! as Filter
            let option = filter.options[indexPath.row]
            option.selected = switchView.isOn
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = self.model!.filters[indexPath.section]
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
    }
    
    /*func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        
        switchStates[indexPath.row] = value
    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.model!.filters.count
    }
}
