import ComposableNavigator

/// Handles deeplinks by building the routing path based on a deeplink and replacing the current routing path
public struct DeeplinkHandler {
  private let navigator: Navigator
  private let parser: DeeplinkParser

  public init(navigator: Navigator, parser: DeeplinkParser) {
    self.navigator = navigator
    self.parser = parser
  }

  public func handle(deeplink: Deeplink) {
    if let path = parser.parse(deeplink) {
      navigator.replace(path: path)
    }
  }
}
