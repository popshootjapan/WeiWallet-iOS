//
//  TransactionHistoryViewCell.swift
//  Wei
//
//  Created by yuzushioh on 2018/04/15.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit
import EthereumKit

final class TransactionHistoryViewCell: UITableViewCell, InputAppliable {
    
    @IBOutlet private weak var timestampLabel: UILabel!
    @IBOutlet private weak var transactionTypeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var transactionStatusImageView: UIImageView!
    @IBOutlet private weak var transactionStatusLabel: UILabel!
    @IBOutlet private weak var etherAmountLabel: UILabel!
    
    typealias Input = TransactionHistory
    
    func apply(input: Input) {
        let (transaction, address) = (input.transaction, input.myAddress)
        timestampLabel.text = DateFormatter.fullDateString(from: Date(timeIntervalSince1970: TimeInterval(transaction.timeStamp)!))
        etherAmountLabel.text = Converter.toEther(wei: Wei(transaction.value)!).string
        
        let isReceiveTransaction = transaction.isReceiveTransaction(myAddress: address)
        let transactionTypeText = isReceiveTransaction ? "From" : "To"
        transactionTypeLabel.text = transactionTypeText
        addressLabel.text = isReceiveTransaction ? transaction.from : transaction.to
        
        if transaction.isPending {
            let text = isReceiveTransaction ? "受け取り中" : "送金中"
            transactionStatusLabel.text = text
            transactionStatusImageView.image = #imageLiteral(resourceName: "icon_history_waiting")
        } else {
            let text = isReceiveTransaction ? "受け取り済み" : "送金済み"
            transactionStatusLabel.text = text
            
            let icon = isReceiveTransaction ? #imageLiteral(resourceName: "icon_history_receive") : #imageLiteral(resourceName: "icon_history_send")
            transactionStatusImageView.image = icon
        }
    }
}
