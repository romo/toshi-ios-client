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
import UIKit
import TinyConstraints

protocol BasicCellActionDelegate: class {

    func didChangeSwitchState(_ cell: BasicTableViewCell, _ state: Bool)
    func didTapLeftImage(_ cell: BasicTableViewCell)
    func didFinishTitleInput(_ cell: BasicTableViewCell, text: String?)
    func titleShouldChangeCharactersInRange(_ cell: BasicTableViewCell, text: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

//extension with default implementation which is alternative for optional functions in protocols
extension BasicCellActionDelegate {
    func didTapLeftImage(_ cell: BasicTableViewCell) {}
    func didChangeSwitchState(_ cell: BasicTableViewCell, _ state: Bool) {}
    func didFinishTitleInput(_ cell: BasicTableViewCell, text: String?) {}
}

class BasicTableViewCell: UITableViewCell {

    static let horizontalMargin: CGFloat = 16.0
    static let verticalMargin: CGFloat = 15.0
    static let interItemMargin: CGFloat = 10.0
    static let imageSize: CGFloat = 38.0
    static let doubleImageSize: CGFloat = 48.0
    static let imageMargin: CGFloat = 10.0
    static let doubleImageMargin: CGFloat = 16.0
    static let largeVerticalMargin: CGFloat = 22.0

    weak var actionDelegate: BasicCellActionDelegate?

    lazy var titleTextField: UITextField = {
        let titleTextField = UITextField()

        titleTextField.delegate = self

        titleTextField.font = Theme.preferredRegular()
        titleTextField.isUserInteractionEnabled = false
        titleTextField.adjustsFontForContentSizeCategory = true

        return titleTextField
    }()

    lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()

        subtitleLabel.font = Theme.preferredRegularSmall()
        subtitleLabel.textColor = Theme.lightGreyTextColor

        return subtitleLabel
    }()

    lazy var detailsLabel: UILabel = {
        let detailsLabel = UILabel()

        detailsLabel.font = Theme.preferredFootnote()
        detailsLabel.textAlignment = .right
        detailsLabel.textColor = Theme.lightGreyTextColor

        return detailsLabel
    }()

    lazy var leftImageView: UIImageView = {
        let leftImageView = UIImageView()

        leftImageView.contentMode = .scaleAspectFill
        leftImageView.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLeftImage(_:)))
        leftImageView.addGestureRecognizer(tapGesture)

        return leftImageView
    }()

    lazy var doubleImageView: DoubleImageView = {
        let doubleImageView = DoubleImageView()

        doubleImageView.contentMode = .scaleAspectFill
        doubleImageView.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLeftImage(_:)))
        doubleImageView.addGestureRecognizer(tapGesture)

        return doubleImageView
    }()

    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()

        switchControl.addTarget(self, action: #selector(didChangeSwitchState(_:)), for: .valueChanged)

        return switchControl
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviewsAndConstraints()

        selectionStyle = .none
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func addSubviewsAndConstraints() {
        fatalError("addSubviewsAndConstraints() should be overriden")
    }

    @objc private func didTapLeftImage(_ tapGesture: UITapGestureRecognizer) {
        actionDelegate?.didTapLeftImage(self)
    }

    @objc private func didChangeSwitchState(_ switchControl: UISwitch) {
        actionDelegate?.didChangeSwitchState(self, switchControl.isOn)
    }

    public static func register(in tableView: UITableView) {
        tableView.register(TitleCell.self)
        tableView.register(TitleSubtitleCell.self)
        tableView.register(TitleSwitchCell.self)
        tableView.register(TitleSubtitleSwitchCell.self)
        tableView.register(AvatarTitleCell.self)
        tableView.register(AvatarTitleSubtitleCell.self)
        tableView.register(AvatarTitleSubtitleDetailsCell.self)
        tableView.register(AvatarTitleSubtitleSwitchCell.self)
        tableView.register(DoubleAvatarTitleSubtitleCell.self)
    }
}

extension BasicTableViewCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.actionDelegate?.didFinishTitleInput(self, text: textField.text)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return actionDelegate?.titleShouldChangeCharactersInRange(self, text: textField.text, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
}
