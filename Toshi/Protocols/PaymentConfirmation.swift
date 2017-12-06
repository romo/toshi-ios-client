// Copyright (c) 2017 Token Browser, Inc
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import Foundation

final class PaymentConfirmation {

    public static var shared: PaymentConfirmation = PaymentConfirmation()

    public func present(for parameters: [String: Any], title: String, message: String, presentCompletionHandler: (() -> Void)? = nil, approveHandler: (() -> Void)? = nil, cancelHandler: (() -> Void)? = nil) {

        EthereumAPIClient.shared.transactionSceleton(for: parameters) { sceleton, error in
            var estimatedFeesString = ""

            let confirmationTitle = title
            var messageText = message

            if let gasPrice = sceleton?["gas_price"] as? String, let gas = sceleton?["gas"] as? String {

                let gasPriceValue = NSDecimalNumber(hexadecimalString: gasPrice)
                let gasValue = NSDecimalNumber(hexadecimalString: gas)

                let fee = gasPriceValue.decimalValue * gasValue.decimalValue
                let decimalNumberFee = NSDecimalNumber(decimal: fee)

                let feeEthValueString = EthereumConverter.ethereumValueString(forWei: decimalNumberFee)

                let rate = ExchangeRateClient.exchangeRate
                let fiatValueString = EthereumConverter.fiatValueStringWithCode(forWei: decimalNumberFee, exchangeRate: rate)

                estimatedFeesString = "The estimated Ethereum network fees are \(fiatValueString) (\(feeEthValueString))"
                print("Transaction fee ethereum value: \(estimatedFeesString)")

                messageText.append("\n\n\(estimatedFeesString)")

                DispatchQueue.main.async {
                    presentCompletionHandler?()
                    self.showPaymentConfirmation(title: confirmationTitle, message: messageText, approveHandler: approveHandler, cancelHandler: cancelHandler)
                }

            } else {
                DispatchQueue.main.async {
                    presentCompletionHandler?()
                    self.showPaymentConfirmation(title: confirmationTitle, message: messageText, approveHandler: approveHandler, cancelHandler: cancelHandler)
                }
            }
        }
    }

    private func showPaymentConfirmation(title: String, message: String, approveHandler: (() -> Void)? = nil, cancelHandler: (() -> Void)? = nil) {


        let alert = UIAlertController(title: Localized("payment_request_confirmation_warning_title"), message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: Localized("cancel_action_title"), style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            cancelHandler?()
        }))

        alert.addAction(UIAlertAction(title: Localized("payment_request_confirmation_warning_action_confirm"), style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            approveHandler?()
        }))

        Navigator.presentModally(alert)
    }
}
