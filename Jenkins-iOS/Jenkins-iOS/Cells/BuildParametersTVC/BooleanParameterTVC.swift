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
    
    var name:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(withBooleanParametr parameter: BuildParameter) {
        self.boolSwither.isOn = parameter.type.booleanValue() ?? false
        self.name = parameter.name
    }
    
}

extension BooleanParameterTVC: CellWithSelectedValue {
    func getSelectedValue() -> (name: String, value: String) {
        if self.boolSwither.isOn {
            return (self.name!,"true")
        }else {
            return (self.name!,"false")
        }
    }
}
