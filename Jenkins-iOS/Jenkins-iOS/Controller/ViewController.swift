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
        let jenkins = JenkinsAPI(domainName: "buildserver.mobi",
                                       port: 8989,
                                       path: "/",
                                       token: "bb5424a9537adf2c363515c752b2e2f1",
                                       userId: "konstantin.bondar",
                                       networkClient: NetworkClient()
                                       )
        
//        jenkins.fetchJobs { (responce) in
//            print (responce)
//        }
        
        jenkins.fetchJob("DummySimulator") { (job) in
            print(job)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

