/// Type-erased representation of `Screen` objects
public struct AnyScreen: Hashable, Screen {
    let screen: AnyHashable
    public let presentationStyle: ScreenPresentationStyle

    public init<S: Screen>(_ route: S) {
        screen = route
        presentationStyle = route.presentationStyle
    }

    public func unwrap<S: Screen>() -> S? {
        screen as? S
    }

    public func `is`<S: Screen>(_: S.Type) -> Bool {
        (screen as? S) != nil
    }
}
