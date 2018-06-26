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
        let (kind, address) = (input.kind, input.myAddress)
        
        guard case .remote(let transaction) = kind else {
            return
        }
        
        if let etherAmount = Wei(transaction.value).flatMap({ try? Converter.toEther(wei: $0) })?.string {
            etherAmountLabel.text = etherAmount
        } else {
            etherAmountLabel.text = R.string.localizable.errorEtherFailedToConvert()
        }
        
        timestampLabel.text = DateFormatter.fullDateString(from: Date(timeIntervalSince1970: TimeInterval(transaction.timeStamp)!))
        
        let isReceiveTransaction = transaction.isReceiveTransaction(myAddress: address)
        let transactionTypeText = isReceiveTransaction ? "From" : "To"
        transactionTypeLabel.text = transactionTypeText
        addressLabel.text = isReceiveTransaction ? transaction.from : transaction.to
        
        if transaction.isPending {
            let text = isReceiveTransaction ? R.string.localizable.transactionWatingForReceive() : R.string.localizable.transactionWaitingForSend()
            transactionStatusLabel.text = text
            transactionStatusImageView.image = #imageLiteral(resourceName: "icon_history_waiting")
        } else {
            let text = isReceiveTransaction ? R.string.localizable.transactionReceived() : R.string.localizable.transactionSent()
            transactionStatusLabel.text = text
            
            let icon = isReceiveTransaction ? #imageLiteral(resourceName: "icon_history_receive") : #imageLiteral(resourceName: "icon_history_send")
            transactionStatusImageView.image = icon
        }
    }
}
