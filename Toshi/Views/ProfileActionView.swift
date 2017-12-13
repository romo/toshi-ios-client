import UIKit
import SweetUIKit

class ProfileActionView: UIStackView {

    lazy var messageButton: ActionBarButton = {
        let view = ActionBarButton()
        view.setImage(#imageLiteral(resourceName: "Message").withRenderingMode(.alwaysTemplate))
        view.setTitle(Localized("profile_action_message"))
        view.tintColor = Theme.lightGreyTextColor

        return view
    }()

    lazy var addFavoriteButton: ActionBarButton = {
        let view = ActionBarButton()
        view.setImage(#imageLiteral(resourceName: "Favorites").withRenderingMode(.alwaysTemplate))
        view.setTitle(Localized("profile_action_add_favorite"))
        view.tintColor = Theme.lightGreyTextColor

        return view
    }()

    lazy var payButton: ActionBarButton = {
        let view = ActionBarButton()
        view.setImage(#imageLiteral(resourceName: "Pay").withRenderingMode(.alwaysTemplate))
        view.setTitle(Localized("profile_action_pay"))
        view.tintColor = Theme.lightGreyTextColor

        return view
    }()

    convenience init() {
        self.init(arrangedSubviews: [])

        distribution = .equalSpacing
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.top = 16
        layoutMargins.bottom = 16
        layoutMargins.left = 38
        layoutMargins.right = 38
        
        addArrangedSubview(messageButton)
        addArrangedSubview(addFavoriteButton)
        addArrangedSubview(payButton)

        translatesAutoresizingMaskIntoConstraints = false

        messageButton.widthAnchor.constraint(equalToConstant: 63).isActive = true
        addFavoriteButton.widthAnchor.constraint(equalToConstant: 63).isActive = true
        payButton.widthAnchor.constraint(equalToConstant: 63).isActive = true
    }
}
