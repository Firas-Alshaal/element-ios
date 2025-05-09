// File created from TemplateAdvancedRoomsExample
// $ createSwiftUITwoScreen.sh Spaces/SpaceCreation SpaceCreation SpaceCreationMenu SpaceCreationSettings
//
// Copyright 2021-2024 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
// Please see LICENSE files in the repository root for full details.
//

import Foundation

/// Actions sent by the`ViewModel` to the `Coordinator`.
enum SpaceCreationMenuViewModelAction {
    case didSelectOption(_ optionId: SpaceCreationMenuRoomOptionId)
    case cancel
    case back
}
