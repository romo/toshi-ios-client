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
import SweetUIKit
import CoreImage

open class ProfileController: UIViewController {

    fileprivate var idAPIClient: IDAPIClient {
        return IDAPIClient.shared
    }

    fileprivate lazy var avatarImageView: AvatarImageView = {
        let view = AvatarImageView(withAutoLayout: true)

        return view
    }()

    fileprivate lazy var nameLabel: UILabel = {
        let view = UILabel(withAutoLayout: true)
        view.numberOfLines = 0
        view.font = Theme.regular(size: 24)

        return view
    }()

    fileprivate lazy var usernameLabel: UILabel = {
        let view = UILabel(withAutoLayout: true)
        view.numberOfLines = 0
        view.font = Theme.regular(size: 16)
        view.textColor = Theme.greyTextColor

        return view
    }()

    fileprivate lazy var editProfileButton: UIButton = {
        let view = UIButton(withAutoLayout: true)
        view.setAttributedTitle(NSAttributedString(string: "Edit Profile", attributes: [NSFontAttributeName: Theme.regular(size: 17), NSForegroundColorAttributeName: Theme.tintColor]), for: .normal)
        view.setAttributedTitle(NSAttributedString(string: "Edit Profile", attributes: [NSFontAttributeName: Theme.regular(size: 17), NSForegroundColorAttributeName: Theme.lightGreyTextColor]), for: .highlighted)
        view.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)

        return view
    }()

    fileprivate lazy var editSeparatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = Theme.borderColor
        view.set(height: 1.0 / UIScreen.main.scale)

        return view
    }()

    fileprivate lazy var aboutContentLabel: UILabel = {
        let view = UILabel(withAutoLayout: true)
        view.font = Theme.regular(size: 17)
        view.numberOfLines = 0

        return view
    }()

    fileprivate lazy var locationContentLabel: UILabel = {
        let view = UILabel(withAutoLayout: true)
        view.font = Theme.regular(size: 16)
        view.textColor = Theme.lightGreyTextColor
        view.numberOfLines = 0

        return view
    }()

    fileprivate lazy var contentBackgroundView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = Theme.viewBackgroundColor

        return view
    }()

    fileprivate lazy var contentSeparatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = Theme.settingsBackgroundColor
        view.layer.borderColor = Theme.borderColor.cgColor
        view.layer.borderWidth = 1.0 / UIScreen.main.scale
        view.set(height: 1.0 / UIScreen.main.scale)

        return view
    }()

    fileprivate lazy var reputationSeparatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = Theme.settingsBackgroundColor
        view.layer.borderColor = Theme.borderColor.cgColor
        view.layer.borderWidth = 1.0 / UIScreen.main.scale
        view.set(height: 1.0 / UIScreen.main.scale)

        return view
    }()

    fileprivate lazy var bottomSeparatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = Theme.settingsBackgroundColor
        view.layer.borderColor = Theme.borderColor.cgColor
        view.layer.borderWidth = 1.0 / UIScreen.main.scale
        view.set(height: 1.0 / UIScreen.main.scale)

        return view
    }()

    fileprivate lazy var reputationView: ReputationView = {
        let view = ReputationView(withAutoLayout: true)

        return view
    }()

    fileprivate lazy var reputationBackgroundView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = Theme.viewBackgroundColor

        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = true
        view.delaysContentTouches = false
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)

        return view
    }()

    private lazy var container: UIView = {
        let view = UIView()

        return view
    }()

    public init() {
        super.init(nibName: nil, bundle: nil)

        self.edgesForExtendedLayout = .bottom
        self.title = "Profile"
    }

    public required init?(coder _: NSCoder) {
        fatalError("")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Theme.settingsBackgroundColor

        self.addSubviewsAndConstraints()

        self.reputationView.setScore(.zero)
        self.updateReputation()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let name = TokenUser.current?.name, !name.isEmpty, let username = TokenUser.current?.displayUsername {
            self.nameLabel.text = name
            self.usernameLabel.text = username
        } else if let username = TokenUser.current?.displayUsername {
            self.usernameLabel.text = nil
            self.nameLabel.text = username
        }

        self.aboutContentLabel.text = TokenUser.current?.about
        self.locationContentLabel.text = TokenUser.current?.location

        if let path = TokenUser.current?.avatarPath as String? {
            AvatarManager.shared.avatar(for: path) { image, _ in
                self.avatarImageView.image = image
            }
        }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    fileprivate func addSubviewsAndConstraints() {
        let margin: CGFloat = 15
        let avatarSize = CGSize(width: 60, height: 60)

        view.addSubview(self.scrollView)
        self.scrollView.edges(to: view)

        self.scrollView.addSubview(self.container)
        self.container.edges(to: self.scrollView)
        self.container.width(to: self.scrollView)

        self.container.addSubview(self.contentBackgroundView)

        self.contentBackgroundView.top(to: self.container)
        self.contentBackgroundView.left(to: self.container)
        self.contentBackgroundView.right(to: self.container)

        self.contentBackgroundView.addSubview(self.avatarImageView)
        self.contentBackgroundView.addSubview(self.nameLabel)
        self.contentBackgroundView.addSubview(self.usernameLabel)
        self.contentBackgroundView.addSubview(self.aboutContentLabel)
        self.contentBackgroundView.addSubview(self.locationContentLabel)
        self.contentBackgroundView.addSubview(self.editSeparatorView)
        self.contentBackgroundView.addSubview(self.editProfileButton)
        self.contentBackgroundView.addSubview(self.contentSeparatorView)

        self.avatarImageView.size(avatarSize)
        self.avatarImageView.origin(to: self.contentBackgroundView, insets: CGVector(dx: margin, dy: margin * 2))

        let nameContainer = UILayoutGuide()
        self.contentBackgroundView.addLayoutGuide(nameContainer)

        nameContainer.top(to: self.contentBackgroundView, offset: margin * 2)
        nameContainer.leftToRight(of: self.avatarImageView, offset: margin)
        nameContainer.right(to: self.contentBackgroundView, offset: -margin)

        self.nameLabel.height(25, relation: .equalOrGreater, priority: .high)
        self.nameLabel.top(to: nameContainer)
        self.nameLabel.left(to: nameContainer)
        self.nameLabel.right(to: nameContainer)

        self.usernameLabel.height(25, relation: .equalOrGreater, priority: .high)
        self.usernameLabel.topToBottom(of: self.nameLabel, offset: margin)
        self.usernameLabel.left(to: nameContainer)
        self.usernameLabel.bottom(to: nameContainer)
        self.usernameLabel.right(to: nameContainer)

        self.aboutContentLabel.topToBottom(of: nameContainer, offset: margin)
        self.aboutContentLabel.left(to: self.contentBackgroundView, offset: margin)
        self.aboutContentLabel.right(to: self.contentBackgroundView, offset: -margin)

        self.locationContentLabel.topToBottom(of: self.aboutContentLabel, offset: margin)
        self.locationContentLabel.left(to: self.contentBackgroundView, offset: margin)
        self.locationContentLabel.right(to: self.contentBackgroundView, offset: -margin)

        self.editSeparatorView.height(Theme.borderHeight)
        self.editSeparatorView.topToBottom(of: self.locationContentLabel, offset: margin)
        self.editSeparatorView.left(to: self.contentBackgroundView)
        self.editSeparatorView.right(to: self.contentBackgroundView)

        self.editProfileButton.height(50)
        self.editProfileButton.topToBottom(of: self.editSeparatorView)
        self.editProfileButton.left(to: self.contentBackgroundView)
        self.editProfileButton.right(to: self.contentBackgroundView)

        self.contentSeparatorView.height(Theme.borderHeight)
        self.contentSeparatorView.topToBottom(of: self.editProfileButton)
        self.contentSeparatorView.left(to: self.contentBackgroundView)
        self.contentSeparatorView.right(to: self.contentBackgroundView)
        self.contentSeparatorView.bottom(to: self.contentBackgroundView)

        self.container.addSubview(self.reputationBackgroundView)

        self.reputationBackgroundView.topToBottom(of: self.contentBackgroundView, offset: 66)
        self.reputationBackgroundView.left(to: self.container)
        self.reputationBackgroundView.bottom(to: self.container)
        self.reputationBackgroundView.right(to: self.container)

        self.reputationBackgroundView.addSubview(self.reputationSeparatorView)
        self.reputationBackgroundView.addSubview(self.reputationView)
        self.reputationBackgroundView.addSubview(self.bottomSeparatorView)

        self.reputationSeparatorView.height(Theme.borderHeight)
        self.reputationSeparatorView.top(to: self.reputationBackgroundView)
        self.reputationSeparatorView.left(to: self.reputationBackgroundView)
        self.reputationSeparatorView.right(to: self.reputationBackgroundView)

        self.reputationView.topToBottom(of: self.reputationSeparatorView, offset: 40)
        self.reputationView.left(to: self.reputationBackgroundView, offset: 34)
        self.reputationView.right(to: self.reputationBackgroundView, offset: -40)

        self.bottomSeparatorView.height(Theme.borderHeight)
        self.bottomSeparatorView.topToBottom(of: self.reputationView, offset: 40)
        self.bottomSeparatorView.left(to: self.reputationBackgroundView)
        self.bottomSeparatorView.right(to: self.reputationBackgroundView)
        self.bottomSeparatorView.bottom(to: self.reputationBackgroundView)
    }

    fileprivate func updateReputation() {
        guard let currentUser = TokenUser.current as TokenUser? else { return }

        RatingsClient.shared.scores(for: currentUser.address) { ratingScore in
            self.reputationView.setScore(ratingScore)
        }
    }

    @objc
    fileprivate func didTapEditProfileButton() {
        let editController = ProfileEditController()
        self.navigationController?.pushViewController(editController, animated: true)
    }
}
