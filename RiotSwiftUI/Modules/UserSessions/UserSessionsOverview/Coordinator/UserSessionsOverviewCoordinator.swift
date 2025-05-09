//
// Copyright 2022-2024 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
// Please see LICENSE files in the repository root for full details.
//

import CommonKit
import SwiftUI

struct UserSessionsOverviewCoordinatorParameters {
    let session: MXSession
    let service: UserSessionsOverviewService
}

final class UserSessionsOverviewCoordinator: Coordinator, Presentable {
    private let parameters: UserSessionsOverviewCoordinatorParameters
    private let hostingViewController: UIViewController
    private var viewModel: UserSessionsOverviewViewModelProtocol
    private let service: UserSessionsOverviewService

    private var indicatorPresenter: UserIndicatorTypePresenterProtocol
    private var loadingIndicator: UserIndicator?
    
    // Must be used only internally
    var childCoordinators: [Coordinator] = []
    var completion: ((UserSessionsOverviewCoordinatorResult) -> Void)?

    init(parameters: UserSessionsOverviewCoordinatorParameters) {
        self.parameters = parameters
        service = parameters.service
        
        let shouldShowDeviceLogout = parameters.session.homeserverWellknown.authentication == nil
        viewModel = UserSessionsOverviewViewModel(userSessionsOverviewService: parameters.service,
                                                  settingsService: RiotSettings.shared,
                                                  showDeviceLogout: shouldShowDeviceLogout)
        
        hostingViewController = VectorHostingController(rootView: UserSessionsOverview(viewModel: viewModel.context))
        hostingViewController.vc_setLargeTitleDisplayMode(.never)
        hostingViewController.vc_removeBackTitle()
        
        indicatorPresenter = UserIndicatorTypePresenter(presentingViewController: hostingViewController)
    }
    
    // MARK: - Public
    
    func start() {
        MXLog.debug("[UserSessionsOverviewCoordinator] did start.")
        viewModel.completion = { [weak self] result in
            guard let self = self else { return }
            MXLog.debug("[UserSessionsOverviewCoordinator] UserSessionsOverviewViewModel did complete with result: \(result).")
            
            switch result {
            case let .showOtherSessions(sessionInfos: sessionInfos, filter: filter):
                self.showOtherSessions(sessionInfos: sessionInfos, filterBy: filter)
            case .verifyCurrentSession:
                self.completion?(.verifyCurrentSession)
            case .renameSession(let sessionInfo):
                self.completion?(.renameSession(sessionInfo))
            case .logoutOfSession(let sessionInfo):
                self.completion?(.logoutOfSession(sessionInfo))
            case let .showCurrentSessionOverview(sessionInfo):
                self.showCurrentSessionOverview(sessionInfo: sessionInfo)
            case let .showUserSessionOverview(sessionInfo):
                self.showUserSessionOverview(sessionInfo: sessionInfo)
            case .linkDevice:
                self.completion?(.linkDevice)
            case let .logoutFromUserSessions(sessionInfos: sessionInfos):
                self.completion?(.logoutFromUserSessions(sessionInfos: sessionInfos))
            }
        }
    }
    
    func toPresentable() -> UIViewController {
        hostingViewController
    }
    
    func refreshData() {
        viewModel.context.send(viewAction: .viewAppeared)
    }
    
    // MARK: - Private
    
    /// Show an activity indicator whilst loading.
    /// - Parameters:
    ///   - label: The label to show on the indicator.
    ///   - isInteractionBlocking: Whether the indicator should block any user interaction.
    private func startLoading(label: String = VectorL10n.loading, isInteractionBlocking: Bool = true) {
        loadingIndicator = indicatorPresenter.present(.loading(label: label, isInteractionBlocking: isInteractionBlocking))
    }
    
    /// Hide the currently displayed activity indicator.
    private func stopLoading() {
        loadingIndicator = nil
    }
    
    private func showOtherSessions(sessionInfos: [UserSessionInfo], filterBy filter: UserOtherSessionsFilter) {
        completion?(.openOtherSessions(sessionInfos: sessionInfos, filter: filter))
    }
    
    private func startVerifyCurrentSession() {
        // TODO:
    }
    
    private func showCurrentSessionOverview(sessionInfo: UserSessionInfo) {
        completion?(.openSessionOverview(sessionInfo: sessionInfo))
    }
    
    private func showUserSessionOverview(sessionInfo: UserSessionInfo) {
        completion?(.openSessionOverview(sessionInfo: sessionInfo))
    }
}
