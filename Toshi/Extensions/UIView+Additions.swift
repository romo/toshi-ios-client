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

extension UIView {

    static func highlightAnimation(_ animations: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .easeOutFromCurrentStateWithUserInteraction, animations: animations, completion: nil)
    }

    func bounce() {
        transform = CGAffineTransform(scaleX: 0.98, y: 0.98)

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 200, options: .easeOutFromCurrentStateWithUserInteraction, animations: {
            self.transform = .identity
        }, completion: nil)
    }

    func shake() {
        transform = CGAffineTransform(translationX: 10, y: 0)

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 50, options: .easeOutFromCurrentStateWithUserInteraction, animations: {
            self.transform = .identity
        }, completion: nil)
    }

    func prepareForSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        setContentCompressionResistancePriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)
        setContentHuggingPriority(.required, for: .horizontal)
    }

    func circleify() {
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    func showDebugBorder(color: UIColor) {
        #if DEBUG
            layer.borderColor = color.cgColor
            layer.borderWidth = 1
        #endif
    }
}
