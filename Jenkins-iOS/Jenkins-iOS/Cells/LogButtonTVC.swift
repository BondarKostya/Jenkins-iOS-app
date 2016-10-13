//
//  LogButtonTVC.swift
//  Jenkins-iOS
//
//  Created by mini on 10/6/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class LogButtonTVC: UITableViewCell {

    @IBOutlet weak var logButton: UIButton!
    
    var buttonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func logAction(_ sender: AnyObject) {
        if let buttonAction = buttonAction {
            buttonAction()
        }
    }
    

}
