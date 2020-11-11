import ComposableArchitecture

public struct RouterState: Equatable {
  var path: [IdentifiedScreen]

  public init<Root: Screen>(root: Root) {
    self.path = [
      IdentifiedScreen(id: .root, content: root)
    ]
  }

  public init(path: [IdentifiedScreen]) {
    self.path = path
  }

  func screen(with id: ScreenID) -> IdentifiedScreen? {
    path.first(where: { $0.id == id })
  }

  func tail(from id: ScreenID) -> [IdentifiedScreen]? {
    guard let index = path.firstIndex(where: { $0.id == id }) else {
      return nil
    }

    return Array(path.suffix(from: index))
  }
}

public enum RouterAction: Equatable {
  /// Appends the provided route to the current path
  case go(to: AnyScreen)
  /// Appends the provided route to the current path
  public static func go<S: Screen>(to screen: S) -> RouterAction {
    .go(to: screen.eraseToAnyScreen())
  }

  /// Searches for the first occurence of the provided route in the path and moves back to it
  case goBack(to: AnyScreen)
  /// Searches for the first occurence of the provided route in the path and moves back to it
  public static func goBack<S: Screen>(to route: S) -> RouterAction {
    .goBack(to: route.eraseToAnyScreen())
  }

  /// Replaces the current navigation path with the provided path
  case replace(path: [AnyScreen])
  /// Replaces the current navigation path with the provided path
  public static func replace(path: AnyScreen...) -> RouterAction {
    .replace(path: path)
  }

  /// Dimisses the screen identified by the provided id. This leads either to a pop or sheet dismiss, depending on the screen presentation style
  case dismiss(ScreenID)
  case dismissSuccessor(of: ScreenID)

  case didAppear(ScreenID)
}

public struct RouterEnvironment {
  let screenID: () -> ScreenID

  public init(screenID: @escaping () -> ScreenID) {
    self.screenID = screenID
  }
}

public let routerReducer = Reducer<
  RouterState,
  RouterAction,
  RouterEnvironment
> { state, action, environment in
  switch action {
    case let .go(to: successor):
      guard !state.path.isEmpty else {
        state.path = [
          IdentifiedScreen(id: .root, content: successor)
        ]

        return .none
      }

      state.path
        .append(
          IdentifiedScreen(id: environment.screenID(), content: successor)
        )
      return .none
    case let .goBack(to: predecessor):
      let reversedPath = state.path.reversed()

      guard let index = reversedPath.firstIndex(
        where: { $0.content == predecessor }
      ) else {
        return .none
      }

      state.path = reversedPath
        .suffix(from: index)
        .reversed()

      return .none
    case let .replace(path: path):
      let newPath = path.enumerated().map { (index, element) -> IdentifiedScreen in
        let id = index == 0 ? ScreenID.root: environment.screenID()
        return IdentifiedScreen(id: id, content: element)
      }

      state.path = newPath
      return .none
    case let .dismiss(id):
      guard id != state.path.first?.id, let index = state.path.firstIndex(where: { $0.id == id }) else {
        return .none
      }

      state.path = Array(state.path.prefix(upTo: index))
      return .none
    case let .dismissSuccessor(of: id):
      guard let index = state.path.firstIndex(where: { $0.id == id }) else {
        return .none
      }

      state.path = Array(state.path.prefix(upTo: index.advanced(by: 1)))

      return .none
    case let .didAppear(id):
      state.path = state.path.map { pathElement in
        guard pathElement.id == id else {
          return pathElement
        }
        var new = pathElement
        new.didAppear = true
        return new
      }
      return .none
  }
}
