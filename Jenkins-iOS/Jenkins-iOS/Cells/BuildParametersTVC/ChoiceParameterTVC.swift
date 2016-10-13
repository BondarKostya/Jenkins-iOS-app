//
//  ChoiseParameterTVC.swift
//  Jenkins-iOS
//
//  Created by mini on 10/12/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class ChoiceParameterTVC: UITableViewCell {
    
   @IBOutlet weak var choiceBtn: UIButton!
    var choices = [String]()
    
    var selectedIndex = 0
    var name : String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func choiceAction(_ sender: AnyObject) {
        ActionSheetStringPicker.show(withTitle: "", rows: self.choices, initialSelection: self.selectedIndex, doneBlock: {[weak weakSelf = self] (picker, selectedIndex, selectedValue) in
            guard let selectedValue = selectedValue as? String else {
                return
            }
            weakSelf?.selectedIndex = selectedIndex
            weakSelf?.choiceBtn.setTitle(selectedValue, for: .normal)
            
            }, cancel: { (picker) in
                
            }, origin: self)
    }

    func setupCell(withBooleanParametr parameter: BuildParameter) {
        self.choices = parameter.type.choiceValue() ?? []
        self.name = parameter.name
        
        self.choiceBtn.setTitle(choices.first ?? "", for: .normal)
        
    }
}

extension ChoiceParameterTVC: CellWithSelectedValue {
        
    func getSelectedValue() -> (name: String, value: String) {
        return (self.name!, self.choices[self.selectedIndex])
    }
}
