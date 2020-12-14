import SwiftUI

public extension PathBuilder {
  /**
   Creates a path builder responsible for a single screen.

   - Parameters:
   - onAppear:
   Called whenever the screen appears. The passed bool is true, if it is the screens initial appear.
   - content:
   Closure describing how to build a SwiftUI view given the screen data.
   - nesting:
   Any path builder that can follow after this screen
   */
  static func screen<S: Screen, Content: View>(
    onAppear: @escaping (Bool) -> Void = { _ in },
    @ViewBuilder content build: @escaping (S) -> Content,
    nesting: PathBuilder? = nil
  ) -> PathBuilder {
    PathBuilder(
      buildPath: { (path: [IdentifiedScreen]) -> Routed? in
        guard let head = path.first, let unwrapped: S = head.content.unwrap() else {
          return nil
        }

        return Routed(
          screen: head,
          successors: Array(path[1...]),
          content: build(unwrapped),
          onAppear: onAppear,
          next: nesting?.build(path:)
        )
      }
    )
  }

  /**
   Creates a path builder responsible for a single screen type, ignoring any attributes of the screen.

   - Parameters:
   - type:
   Defines which screens are handled by the path builder.
   - onAppear:
   Called whenever the screen appears. The passed bool is true, if it is the screens initial appear.
   - content:
   Closure describing how to build a SwiftUI view, if the current path element is of the defined screen type.
   - nesting:
   Any path builder that can follow after this screen
   */
  static func screen<S: Screen, Content: View>(
    _ type: S.Type,
    onAppear: @escaping (Bool) -> Void = { _ in },
    @ViewBuilder content build: @escaping () -> Content,
    nesting: PathBuilder? = nil
  ) -> PathBuilder {
    PathBuilder(
      buildPath: { (path: [IdentifiedScreen]) -> Routed? in
        guard let head = path.first, head.content.is(S.self) else {
          return nil
        }

        return Routed(
          screen: head,
          successors: Array(path[1...]),
          content: build(),
          onAppear: onAppear,
          next: nesting?.build(path:)
        )
      }
    )
  }
}
