import ComposableDeeplinking
import Foundation

extension DeeplinkParser {
    /// Parses all supported deeplinks in the example app
    ///
    /// Supported deeplinks:
    /// * example://home/settings
    /// * example://detail?id={id}
    static let exampleApp: DeeplinkParser = .anyOf(
        .detailSettings
    )
}
