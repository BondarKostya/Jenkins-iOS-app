//
//  TextParameterTVC.swift
//  Jenkins-iOS
//
//  Created by mini on 10/12/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class TextParameterTVC: UITableViewCell {

    @IBOutlet weak var parameterTextView: UITextView!
    
    var name : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(withBooleanParametr parameter: BuildParameter) {
        self.parameterTextView.text = parameter.type.textValue() ?? ""
        self.name = parameter.name
    }

}

extension TextParameterTVC: CellWithSelectedValue {
    
    func getSelectedValue() -> (name: String, value: String) {
        return (self.name!, self.parameterTextView.text!)
    }
}
