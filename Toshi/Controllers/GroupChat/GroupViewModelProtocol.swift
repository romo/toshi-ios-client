//
//  GroupViewModelProtocol.swift
//  Toshi
//
//  Created by Yuliia Veresklia on 28/11/2017.
//  Copyright © 2017 Bakken&Baeck. All rights reserved.
//

import UIKit

enum GroupItemType: Int {
    case avatarTitle
    case notifications
    case isPublic
    case participant
    case addParticipant
    case exitGroup
}

struct GroupInfo {
    let placeholder = Localized("new_group_title")
    var title: String = ""
    var avatar = UIImage(named: "avatar-edit")!
    var isPublic = false
    var notificationsOn = true
    var participantsIDs: [String] = []
}

protocol GroupViewModelCompleteActionDelegate: class {

    func groupViewModelDidFinishCreateOrUpdate()
    func groupViewModelDidStartCreateOrUpdate()
    func groupViewModelDidRequireReload(_ viewModel: GroupViewModelProtocol)
}

protocol GroupViewModelProtocol: class {

    var sectionModels: [TableSectionData] { get }
    var viewControllerTitle: String { get }
    var rightBarButtonTitle: String { get }
    var imagePickerTitle: String { get }
    var imagePickerCameraActionTitle: String { get }
    var imagePickerLibraryActionTitle: String { get }
    var imagePickerCancelActionTitle: String { get }

    var groupThread: TSGroupThread? { get }

    var errorAlertTitle: String { get }
    var errorAlertMessage: String { get }

    var rightBarButtonSelector: Selector { get }

    var participantsIDs: [String] { get }

    func updateAvatar(to image: UIImage)
    func updatePublicState(to isPublic: Bool)
    func updateNotificationsState(to notificationsOn: Bool)
    func updateTitle(to title: String)
    func updateParticipantsIds(to participantsIds: [String])

    var isDoneButtonEnabled: Bool { get }

    var completeActionDelegate: GroupViewModelCompleteActionDelegate? { get set }
}
