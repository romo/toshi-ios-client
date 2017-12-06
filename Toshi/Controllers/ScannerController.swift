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

import UIKit
import CameraScanner

class ScannerController: ScannerViewController {

    var isStatusBarHidden = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private lazy var activityView: UIActivityIndicatorView = {
        self.defaultActivityIndicator()
    }()

    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    override func setupToolbarItems() {
        toolbar.setItems([self.cancelItem], animated: true)
    }

    func approvePayment(with parameters: [String: Any], userInfo: UserInfo, transaction: String?, error: ToshiError?) {
        isStatusBarHidden = false
        guard !userInfo.isLocal else {
            if let tabbarController = self.presentingViewController as? TabBarController {
                tabbarController.openPaymentMessage(to: userInfo.address, parameters: parameters, transaction: transaction)
            }

            return
        }

        showActivityIndicator()

        guard let transaction = transaction else {
                self.hideActivityIndicator()
                self.presentPaymentError(withErrorMessage: error?.localizedDescription ?? ToshiError.genericError.description)
                self.startScanning()

                return
        }

        let signedTransaction = self.createSignedTransaction(from: transaction)

        sendTransaction(originalTransaction: transaction, signedTransaction: signedTransaction)
    }
}

extension ScannerController: ActivityIndicating {

    var activityIndicator: UIActivityIndicatorView {
        return activityView
    }
}

extension ScannerController: PaymentPresentable {

    func setStatusBarHidden(_: Bool) {
        isStatusBarHidden = true
        setNeedsStatusBarAppearanceUpdate()
    }

    func paymentFailed() {
        startScanning()
        isStatusBarHidden = false
        startScanning()
    }

    func paymentDeclined() {
        isStatusBarHidden = false
        startScanning()
    }

    func paymentApproved(with parameters: [String: Any], userInfo: UserInfo) {
        isStatusBarHidden = false
        guard !userInfo.isLocal else {
            if let tabbarController = self.presentingViewController as? TabBarController {
                // we do not use that alert view currently, need to adjust unsigned tramsaction here, pass nil now
                tabbarController.openPaymentMessage(to: userInfo.address, parameters: parameters, transaction: nil)
            }

            return
        }

        showActivityIndicator()

        EthereumAPIClient.shared.createUnsignedTransaction(parameters: parameters) { [weak self] transaction, error in
            
            guard
                let transaction = transaction,
                let signedTransaction = self?.createSignedTransaction(from: transaction) else {
                    self?.hideActivityIndicator()
                    self?.presentPaymentError(withErrorMessage: error?.localizedDescription ?? ToshiError.genericError.description)
                    self?.startScanning()

                    return
            }

            self?.sendTransaction(originalTransaction: transaction, signedTransaction: signedTransaction)
        }
    }
    
    private func createSignedTransaction(from unsignedTransaction: String) -> String {
        return "0x\(Cereal.shared.signWithWallet(hex: unsignedTransaction))"
    }
    
    private func sendTransaction(originalTransaction: String, signedTransaction: String) {
        EthereumAPIClient.shared.sendSignedTransaction(originalTransaction: originalTransaction, transactionSignature: signedTransaction) { [weak self] success, _, error in
            
            self?.hideActivityIndicator()
            
            guard success else {
                self?.presentPaymentError(withErrorMessage: error?.description ?? ToshiError.genericError.description)
                self?.startScanning()

                return
            }
            
            self?.presentSuccessAlert { [weak self] _ in
                self?.startScanning()
            }
        }
    }
}
