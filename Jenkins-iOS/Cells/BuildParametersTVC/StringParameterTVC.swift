//
//  StringParameterTVC.swift
//  Jenkins-iOS
//
//  Created by mini on 10/12/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class StringParameterTVC: UITableViewCell {

    @IBOutlet weak var parameterTextField: UITextField!
    
    var name : String?
    
    func setupCell(withStringParameter parameter: BuildParameter) {
        self.parameterTextField.text = parameter.type.stringValue() ?? ""
        self.name = parameter.name
    }

    

}

extension StringParameterTVC: CellWithSelectedValue {
    
    func getSelectedValue() -> (name: String, value: String) {
        return (self.name!, self.parameterTextField.text!)
    }
}
