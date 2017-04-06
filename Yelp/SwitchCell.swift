
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

        yelpSwitch.thumbImage = #imageLiteral(resourceName: "Yelp")
        yelpSwitch.addTarget(self, action: #selector(SwitchCell.switchValueChanged), for: UIControlEvents.valueChanged)
        yelpSwitch.onTintColor = UIColor.blue
        self.accessoryView = yelpSwitch
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchValueChanged() {
        print("switchValuechanged")
        delegate?.switchCell?(switchCell: self, didChangeValue: yelpSwitch.on)
    }
}
