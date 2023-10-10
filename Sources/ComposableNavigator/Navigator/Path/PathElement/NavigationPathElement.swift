public enum NavigationPathElement: Hashable {
    case screen(IdentifiedScreen)

    public var id: ScreenID {
        switch self {
        case let .screen(screen):
            return screen.id
        }
    }

    public func ids() -> Set<ScreenID> {
        switch self {
        case let .screen(screen):
            return [screen.id]
        }
    }

    public var content: AnyScreen {
        switch self {
        case let .screen(screen):
            return screen.content
        }
    }

    public var hasAppeared: Bool {
        switch self {
        case let .screen(screen):
            return screen.hasAppeared
        }
    }
}
