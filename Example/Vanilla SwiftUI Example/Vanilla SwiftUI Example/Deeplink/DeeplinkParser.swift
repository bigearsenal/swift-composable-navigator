import ComposableDeeplinking

extension DeeplinkParser {
    /// example://detail?id={id}/capacity
    static let detailSettings = DeeplinkParser(
        parse: { deeplink in
            print(deeplink)
            guard deeplink.components.count == 2,
                  deeplink.components[0].name == "detail",
                  case let .value(id) = deeplink.components[0].arguments?["id"],
                  deeplink.components[1].name == "capacity"
            else {
                return []
            }

            return [
                HomeScreen().eraseToAnyScreen(),
                DetailScreen(id: Int(id), train: nil).eraseToAnyScreen(),
                CapacityScreen(capacity: 3).eraseToAnyScreen(),
            ]
        }
    )
}
