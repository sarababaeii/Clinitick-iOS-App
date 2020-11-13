//
//  DiseasesTableViewDelegate.swift
//  Brandent
//
//  Created by Sara Babaei on 10/30/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class DiseasesTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
   
    var diseases = [Disease]()
    
    //MARK: Initializer
    override init() {
        if let diseases = Info.dataController.fetchAllDiseases() as? [Disease] {
            self.diseases = diseases
        }
    }
    
    //MARK: Protocol Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diseases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiseaseCellID", for: indexPath) as! DiseaseTableViewCell
        if let disease = diseaseDataSource(indexPath: indexPath) {
            cell.setAttributes(disease: disease)
        }
        return cell
    }
    
    func diseaseDataSource(indexPath: IndexPath) -> Disease? {
        if indexPath.row < diseases.count {
            return diseases[diseases.count - indexPath.row - 1]
        }
        return nil
    }
}
