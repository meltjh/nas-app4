//
//  TaskTableViewCell.swift
//  melissatjhia-pset4
//
//  Created by Melissa Tjhia on 21-11-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    
    private var cellInfo: [String: AnyObject] = [:]
    
    // Setting and accessing the celldata
    var cellData: [String: AnyObject] {
        get {
            return cellInfo
        }
        set(data) {
            self.cellInfo = data
            self.taskLabel.text = data["task"] as! String?
            let cellChecked = data["checked"] as! Bool
            
            if cellChecked {
                strikeThrough()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Strikes through the task string if it is checked.
    func strikeThrough() {
        let attribute: NSMutableAttributedString =  NSMutableAttributedString(string: self.taskLabel.text!)
        attribute.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attribute.length))
        self.taskLabel.attributedText = attribute
    }
    
}
