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

/// SOFA::Status:{
//      "type": "added",
//      "subject": "Robert"
//      "object": "Marek"
//  }
final class SofaStatus: SofaWrapper {
    enum StatusType: String {
        case leave
        case added
        case changePhoto
        case rename
        case none
    }

    override var type: SofaType {
        return .status
    }

    var statusType: StatusType {
        var statusType = StatusType.none

        if let statusJSON = json["type"] as? String {
            statusType = StatusType(rawValue: statusJSON) ?? .none
        }

        return statusType
    }
    // The types of the object and subjects of the action will probably be user id's int he end
    var subject: String? {
        return json["subject"] as? String
    }
    
    // object is optional since this is only used in added "Marek added Robert" (where Robert is the subject)
    var object: String? {
        return json["object"] as? String
    }

    var attributedText: NSAttributedString? {
        guard let subject = subject else { return nil }

       switch statusType {
       case .leave:
        break
       case .added:
           guard let object = object else { return nil }
           return attributedStringFor(Localized("status_type_added"), with: [subject, object])
       case .changePhoto:
        break
       case .rename:
           guard let object = object else { return nil }
           return attributedStringFor(Localized("status_type_rename"), with: [subject, object])
       default:
        break
       }

        return nil
    }

    private func attributedStringFor(_ string: String, with boldStrings: [String]) -> NSAttributedString {
        let string = String(format: string, arguments: boldStrings)
        var attributedString = NSMutableAttributedString(string: string)

        var normalAttributes = [NSAttributedStringKey.font : Theme.preferredFootnote()]
        attributedString.addAttributes(normalAttributes, range: string.nsRange(forSubstring: string))
        var boldAttributes = [NSAttributedStringKey.font : Theme.bold(size: 13)]

        for boldString in boldStrings {
            attributedString.addAttributes(boldAttributes, range: string.nsRange(forSubstring: boldString))
        }

        return attributedString
    }

    convenience init(body: String) {
        self.init(content: ["body": body])
    }
}