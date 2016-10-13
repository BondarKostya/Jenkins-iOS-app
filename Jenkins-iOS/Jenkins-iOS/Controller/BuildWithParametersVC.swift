//
//  BuildWithParametersVC.swift
//  Jenkins-iOS
//
//  Created by mini on 10/13/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit
import MBProgressHUD

class BuildWithParametersVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var buildParameters = [BuildParameter?]()
    var job: Job?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Build with Parameters"
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 140.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let buildButton = UIBarButtonItem(title: "Build", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BuildWithParametersVC.doneAction))
        self.navigationItem.rightBarButtonItem = buildButton
        self.loadBuildParameters()
        
    }

    func doneAction() {
        var parameters = [String : String]()
        for section in 0..<buildParameters.count {
            let indexPath = NSIndexPath(row: 0, section: section)
            guard let cellWithValue = self.tableView.cellForRow(at: indexPath as IndexPath) as? CellWithSelectedValue else {
                continue
            }
            
            let (name,value) = cellWithValue.getSelectedValue()
            parameters[name] = value
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        JenkinsAPI.sharedInstance.build((self.job?.name)!, parameters: parameters) { (error) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                if let error = error {
                    AlertManager.showError(inVC: self, error.localizedDescription)
                    return
                }
                AlertManager.showAlert(withTitle: "Success", message: "Build started", inVC: self)
            }
        }
    }
    
    func loadBuildParameters() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        JenkinsAPI.sharedInstance.fetchBuildParameters(withJobURL: (self.job?.url)!, callback: { (buildParameters, error) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                if let error = error {
                    AlertManager.showError(inVC: self, error.localizedDescription)
                    return
                }
                self.buildParameters = buildParameters
                self.tableView.reloadData()
            }
            
        })
    }
}

extension BuildWithParametersVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.buildParameters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let buildParameter = self.buildParameters[section] else {
            return ""
        }
        return "\(buildParameter.name):"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let buildParameter = self.buildParameters[section] else {
            return ""
        }
        return "\(buildParameter.description)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let buildParameter = self.buildParameters[indexPath.section] else {
            return UITableViewCell()
        }
        switch buildParameter.type {
        case .boolean:
            let booleanCell = tableView.dequeueReusableCell(withIdentifier: "BooleanParameterTVC", for: indexPath) as! BooleanParameterTVC
            
            booleanCell.setupCell(withBooleanParametr: buildParameter)
            return booleanCell
        case .string:
            let stringCell = tableView.dequeueReusableCell(withIdentifier: "StringParameterTVC", for: indexPath) as! StringParameterTVC
            
            stringCell.setupCell(withBooleanParametr: buildParameter)
            return stringCell
        case .text:
            let textCell = tableView.dequeueReusableCell(withIdentifier: "TextParameterTVC", for: indexPath) as! TextParameterTVC
            
            textCell.setupCell(withBooleanParametr: buildParameter)
            return textCell
        case .choice:
            let choiceCell = tableView.dequeueReusableCell(withIdentifier: "ChoiceParameterTVC", for: indexPath) as! ChoiceParameterTVC
            
            choiceCell.setupCell(withBooleanParametr: buildParameter)
            return choiceCell
        }
    }
}
