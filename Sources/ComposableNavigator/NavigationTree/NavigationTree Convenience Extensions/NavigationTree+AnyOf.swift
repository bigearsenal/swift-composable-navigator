public extension NavigationTree {
    func AnyOf<P: PathBuilder>(
        @NavigationTreeBuilder _ builder: () -> P
    ) -> P {
        builder()
    }
}
