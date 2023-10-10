import ComposableDeeplinking
import ComposableNavigator
import SwiftUI

let trains: [Train] = [
    Train(id: 1, name: "ICE", capacity: 403),
    Train(id: 2, name: "Regio", capacity: 380),
    Train(id: 3, name: "SBahn", capacity: 184),
    Train(id: 4, name: "IC", capacity: 468),
]

@main
struct Vanilla_SwiftUI_ExampleApp: App {
    let navigator: Navigator
    let dataSource: Navigator.Datasource
    let deeplinkHandler: DeeplinkHandler

    init() {
        dataSource = .init(root: HomeScreen())
        navigator = Navigator(dataSource: dataSource)

        deeplinkHandler = DeeplinkHandler(
            navigator: navigator,
            parser: DeeplinkParser.exampleApp
        )
    }

    var body: some Scene {
        WindowGroup {
            Root(dataSource: dataSource, pathBuilder: HomeScreen.Builder())
                .onOpenURL(
                    perform: { url in
                        // the matching parameter needs to match the URL
                        // scheme defined in the application's project file
                        if let deeplink = Deeplink(url: url, matching: "example") {
                            deeplinkHandler.handle(deeplink: deeplink)
                        }
                    }
                )
        }
    }
}
