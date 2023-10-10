public extension NavigationTreeBuilder {
    static func buildEither<P: PathBuilder>(first component: P) -> P {
        component
    }

    static func buildEither<P: PathBuilder>(second component: P) -> P {
        component
    }

    static func buildOptional<P: PathBuilder>(_ component: P?) -> some PathBuilder {
        PathBuilders.if(let: { component }, then: { component in component })
    }
}
