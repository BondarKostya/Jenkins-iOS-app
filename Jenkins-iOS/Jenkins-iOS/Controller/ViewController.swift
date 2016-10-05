//
//  ViewController.swift
//  Jenkins-iOS
//
//  Created by mini on 10/5/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            let jenkins = try Jenkins(host: "buildserver.mobi",
                                       port: 8989,
                                       user: "konstantin.bondar",
                                       token: "bb5424a9537adf2c363515c752b2e2f1",
                                       path: "/")
            print("ad")
            jenkins.fetchJobs { jobs in
                print("Jobs \(jobs)")
            }

        }catch let error as Error {
            print(error)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

