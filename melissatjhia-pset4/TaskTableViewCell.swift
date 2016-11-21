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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
