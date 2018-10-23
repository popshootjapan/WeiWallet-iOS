//
//  PrivateNetworkSettingViewController.swift
//  Wei
//
//  Created by Ryo Fukuda on 2018/10/16.
//  Copyright © 2018 yz. All rights reserved.
//

import UIKit

final class PrivateNetworkSettingViewController: UITableViewController {
    
    var viewModel: PrivateNetworkSettingViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let font = viewModel.isSelected() ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
        cell.textLabel?.font = font
        
        let color = viewModel.isSelected() ? UIColor.wei.success : UIColor.wei.black
        cell.textLabel?.textColor = color
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTextFieldAlertController()
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    private func showTextFieldAlertController() {
        let alertController = UIAlertController(
            title: "Need Information",
            message: "Type node endpoint and chain ID",
            preferredStyle: .alert
        )
        
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Endpoint"
            textField.keyboardType = .URL
        })
        
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Network ID"
            textField.keyboardType = .decimalPad
        })
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] action in
            guard let textFields = alertController.textFields else {
                return
            }
            
            let endpointTextField = textFields[0] as UITextField
            let chainIDTextField = textFields[1] as UITextField
            
            guard let endpointText = endpointTextField.text, let url = URL(string: endpointText) else {
                self?.presentInvalidURLAlert()
                return
            }
            
            guard let chainIDText = chainIDTextField.text, let chainID = Int(chainIDText) else {
                self?.presentInvalidChainID()
                return
            }
            
            self?.viewModel.save(endpoint: url.absoluteString, chainID: chainID)
        })
        
        alertController.addAction(UIAlertAction(title: R.string.localizable.commonCancel(), style: .cancel))
        present(alertController, animated: true)
    }
    
    private func presentInvalidURLAlert() {
        let alertController = UIAlertController(title: "Invalid URL", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    private func presentInvalidChainID() {
        let alertController = UIAlertController(title: "Invalid ChainID", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
