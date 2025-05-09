// 
// Copyright 2021-2024 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
// Please see LICENSE files in the repository root for full details.
//

import UIKit
import Reusable

class CallAudioRouteView: UIView {
    
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var selectedIconImageView: UIImageView!
    @IBOutlet private weak var bottomLineView: UIView!

    let route: MXiOSAudioOutputRoute
    private let isSelected: Bool
    private let isBottomLineHidden: Bool
    
    private var theme: Theme = ThemeService.shared().theme
    
    init(withRoute route: MXiOSAudioOutputRoute,
         isSelected: Bool,
         isBottomLineHidden: Bool = false) {
        self.route = route
        self.isSelected = isSelected
        self.isBottomLineHidden = isBottomLineHidden
        super.init(frame: .zero)
        loadNibContent()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        selectedIconImageView.isHidden = !isSelected
        bottomLineView.isHidden = isBottomLineHidden
        
        switch route.routeType {
        case .builtIn:
            iconImageView.image = Asset.Images.callAudioRouteBuiltin.image
            titleLabel.text = route.name
        case .loudSpeakers:
            iconImageView.image = Asset.Images.callAudioRouteSpeakers.image
            titleLabel.text = VectorL10n.callMoreActionsAudioUseDevice
        case .externalWired, .externalBluetooth, .externalCar:
            iconImageView.image = Asset.Images.callAudioRouteHeadphones.image
            titleLabel.text = route.name
        }
        
        update(theme: theme)
    }
    
}

extension CallAudioRouteView: NibOwnerLoadable {}

extension CallAudioRouteView: Themable {
    
    func update(theme: Theme) {
        self.theme = theme
        
        backgroundColor = theme.colors.navigation
        iconImageView.tintColor = theme.colors.secondaryContent
        titleLabel.textColor = theme.colors.primaryContent
        titleLabel.font = theme.fonts.body
        selectedIconImageView.tintColor = theme.colors.primaryContent
        bottomLineView.backgroundColor = theme.colors.secondaryContent
    }
    
}
