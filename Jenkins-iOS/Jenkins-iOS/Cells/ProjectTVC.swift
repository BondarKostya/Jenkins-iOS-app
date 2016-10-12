//
//  ProjectTVC.swift
//  Jenkins-iOS
//
//  Created by mini on 10/10/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit


class ProjectTVC: UITableViewCell {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var buildStatusImage: UIView!
    
    var buildState = BuildStatus.success
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        weatherImage.image = nil
        projectName.text = ""
        buildStatusImage.backgroundColor = UIColor.clear
    }
    
    func setupCell(withJob job: Job) {
        self.projectName.text = job.name
        self.weatherImage.image = job.projectWeather.image()
        self.buildStatusImage.backgroundColor = job.lastBuildStatus.color()
        
        
        self.weatherImage.layer.cornerRadius = 5
        self.weatherImage.clipsToBounds = true

        self.buildStatusImage.layer.cornerRadius = 8
    }
    
    func setupBuildStatusImage() {
        
    }

}





