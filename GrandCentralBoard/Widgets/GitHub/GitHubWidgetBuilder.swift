//
//  GitHubWidgetBuilder.swift
//  GrandCentralBoard
//
//  Created by Michał Laskowski on 30.05.2016.
//  Copyright © 2016 Macoscope. All rights reserved.
//

import GCBCore


final class GitHubWidgetBuilder: WidgetBuilding {

    let name = "GitHubPullRequests"

    func build(settings: AnyObject) throws -> WidgetControlling {
        let settings = try GitHubWidgetSettings.decode(settings)

        let dataProvider = GitHubDataProvider(accessToken: settings.accessToken)
        let source = GitHubSource(dataProvider: dataProvider, refreshInterval: settings.refreshInterval)
        return GitHubWidget(source: source)
    }
}
