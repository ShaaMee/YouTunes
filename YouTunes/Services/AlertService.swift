//
//  AlertService.swift
//  YouTunes
//
//  Created by Aleksei Pavlov on 31.10.2021.
//

import Foundation
import UIKit

class AlertService {
    static let shared = AlertService()
    
    func showAlertWith(messeage: String, inViewController vc: UIViewController){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Something is wrong", message: messeage, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            vc.present(alert, animated: true) {
                
                guard let controllers = vc.navigationController?.viewControllers else { return }
                
                for controller in controllers {
                    if let controller = controller as? SearchResultsCollectionViewController {
                        controller.isSearching = false
                    }
                }
            }
        }
    }
}
