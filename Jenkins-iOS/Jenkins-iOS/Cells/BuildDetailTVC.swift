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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.buildStatusImage.backgroundColor = UIColor.clear
        self.buildName.text = ""
        self.buildDate.text = ""
    }
    
    func setupCell(withBuild build: Build) {
        self.buildStatusImage.backgroundColor = build.buildStatus.color()
        self.buildStatusImage.layer.cornerRadius = 6
        
        self.buildName.text = "Build \(build.name)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyy hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        let buildDate = NSDate(timeIntervalSince1970: TimeInterval(build.timestamp / 1000))
        
        self.buildDate.text = dateFormatter.string(from: buildDate as Date)
    }

}
