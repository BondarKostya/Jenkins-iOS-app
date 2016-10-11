//
//  ProjectsVC.swift
//  Jenkins-iOS
//
//  Created by mini on 10/10/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProjectsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var jobs = [Job]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Projects"
        self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 40, 0)
        
        self.loadProjects()
    }
    
    func loadProjects() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        JenkinsAPI.sharedInstance.fetchJobs { (jobs, error) in
            
            DispatchQueue.main.async{
                MBProgressHUD.hide(for: self.view, animated: true)
                if let error = error {
                    AlertManager.showError(inVC: self, error.localizedDescription)
                    return
                }
                print(jobs)
                self.jobs = jobs
                self.tableView.reloadData()
            }
            
            
        }
    }
    


}

extension ProjectsVC : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let projectCell = tableView.dequeueReusableCell(withIdentifier: "ProjectTVC", for: indexPath) as! ProjectTVC
        let job = self.jobs[indexPath.row]
        projectCell.setupCell(withName: job.name , projectWeather: job.projectWeather , lastBuildStatus: job.buildStatus)
        return projectCell
        
    }
}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
