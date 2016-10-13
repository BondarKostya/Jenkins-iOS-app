//
//  BooleanParameterTVC.swift
//  Jenkins-iOS
//
//  Created by mini on 10/12/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class BooleanParameterTVC: UITableViewCell {

    @IBOutlet weak var boolSwither: UISwitch!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(withBooleanParametr parameter: BuildParameter) {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
