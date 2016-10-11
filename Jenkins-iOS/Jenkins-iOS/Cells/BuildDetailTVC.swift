//
//  BuildDetailTVC.swift
//  Jenkins-iOS
//
//  Created by mini on 10/11/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class BuildDetailTVC: UITableViewCell {

    @IBOutlet weak var buildStatusImage: UIView!
    @IBOutlet weak var buildName: UILabel!
    @IBOutlet weak var buildDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
