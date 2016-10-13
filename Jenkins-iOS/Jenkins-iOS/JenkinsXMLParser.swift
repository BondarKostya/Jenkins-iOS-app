//
//  XMLParser.swift
//  Jenkins-iOS
//
//  Created by mini on 10/13/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import Foundation
import SWXMLHash

public class JenkinsXMLParser {
    func convertXMLToBuildParatemers(withXMLString: String) -> [BuildParameter?] {
        var parameters = [BuildParameter?]()
        
        let xml = SWXMLHash.parse(withXMLString)
        let parametersXML = xml["project"]["properties"]["hudson.model.ParametersDefinitionProperty"]["parameterDefinitions"].children
        
        for parameterXML in parametersXML {
            let buildParameter = self.parseParameter(parameterXML)
            parameters.append(buildParameter)
        }
        
        return parameters
    }
    
    func parseParameter(_ indexer:XMLIndexer) -> BuildParameter? {
        switch indexer.element!.name{
        case "hudson.model.BooleanParameterDefinition":
            let name = indexer["name"].element!.text!
            let description = indexer["description"].element!.text!
            let defaultValue = indexer["defaultValue"].element!.text ?? ""
            
            let boolValue: Bool = NSString(string:defaultValue).boolValue
            
            let buildParameter = BuildParameter(name: name, description: description, type: .boolean(defaultValue: boolValue))
            return buildParameter
        case "hudson.model.StringParameterDefinition":
            let name = indexer["name"].element!.text!
            let description = indexer["description"].element!.text!
            let defaultValue = indexer["defaultValue"].element!.text ?? ""
            
            let buildParameter = BuildParameter(name: name, description: description, type: .string(defaultValue: defaultValue))
            return buildParameter
        case "hudson.model.TextParameterDefinition":
            let name = indexer["name"].element!.text!
            let description = indexer["description"].element!.text!
            let defaultValue = indexer["defaultValue"].element!.text ?? ""
            
            let buildParameter = BuildParameter(name: name, description: description, type: .text(defaultValue: defaultValue))
            return buildParameter
        case "hudson.model.ChoiceParameterDefinition":
            let name = indexer["name"].element!.text!
            let description = indexer["description"].element!.text!
            let choiceXML = indexer["choices"]["a"].children
            
            var choices = [String]()
            for choice in choiceXML {
                choices.append(choice.element!.text ?? "")
            }
            
            let buildParameter = BuildParameter(name: name, description: description, type: .choice(choices: choices))
            return buildParameter
        default:
            return nil
        }
    }
}
