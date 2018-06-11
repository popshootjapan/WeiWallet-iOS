//
//  LatestTransactionListViewCell.swift
//  Wei
//
//  Created by Ryosuke Fukuda on 2018/04/14.
//  Copyright © 2018 popshoot All rights reserved.
//

import UIKit
import EthereumKit

final class LatestTransactionListViewCell: UITableViewCell, InputAppliable {
    
    @IBOutlet private weak var timestampLabel: UILabel!
    @IBOutlet private weak var transactionStatusImageViewView: UIImageView!
    @IBOutlet private weak var transactionStatusLabel: UILabel!
    @IBOutlet private weak var etherAmountLabel: UILabel!
    
    typealias Input = TransactionHistory
    
    func apply(input: Input) {
        let (transaction, address) = (input.transaction, input.myAddress)
        timestampLabel.text = DateFormatter.fullDateString(from: Date(timeIntervalSince1970: TimeInterval(Int64(transaction.timeStamp)!)))
        etherAmountLabel.text = Converter.toEther(wei: Wei(transaction.value)!).string
        
        let isReceiveTransaction = transaction.isReceiveTransaction(myAddress: address)
        if transaction.isPending {
            let text = isReceiveTransaction ? "受け取り中" : "送金中"
            transactionStatusLabel.text = text
            transactionStatusImageViewView.image = #imageLiteral(resourceName: "icon_card_waiting")
        } else {
            let text = isReceiveTransaction ? "受け取り済み" : "送金済み"
            transactionStatusLabel.text = text
            
            let icon = isReceiveTransaction ? #imageLiteral(resourceName: "icon_card_receive") : #imageLiteral(resourceName: "icon_card_send")
            transactionStatusImageViewView.image = icon
        }
    }
}
