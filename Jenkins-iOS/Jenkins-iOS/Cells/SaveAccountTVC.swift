//
//  SaveAccountTVC.swift
//  Jenkins-iOS
//
//  Created by mini on 10/6/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class SaveAccountTVC: UITableViewCell {

    var switchStateAction: ((Bool) -> Void)?
    @IBAction func saveChanged(_ sender: UISwitch) {
        if let handler = switchStateAction {
            handler(sender.isOn)
        }
    }

    @IBOutlet weak var saveSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
