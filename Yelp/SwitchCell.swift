
import UIKit
import SevenSwitch

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    var yelpSwitch = SevenSwitch()

    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        yelpSwitch.addTarget(self, action: "switchValueChanged", for: UIControlEvents.valueChanged)
        yelpSwitch.frame = CGRect(x: self.frame.width - 60 , y: self.frame.height/2 - 12.5, width: 50, height: 25)
        yelpSwitch.thumbImage = #imageLiteral(resourceName: "Yelp")
        self.addSubview(yelpSwitch)
        
        //onSwitch.addTarget(self, action: "switchValueChanged", for: UIControlEvents.valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchValueChanged() {
        print("switchValuechanged")
        delegate?.switchCell?(switchCell: self, didChangeValue: onSwitch.isOn)
    }
}
