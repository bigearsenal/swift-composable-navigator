import ComposableNavigator
import SwiftUI

struct DetailScreen: Screen {
    let id: Int?
    let train: Train?
    var presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: DetailScreen) in
                    if let train = screen.train {
                        DetailView(train: train)
                    } else if let id = screen.id {
                        DetailView(id: id)
                    } else {
                        EmptyView()
                    }
                },
                nesting: {
                    CapacityScreen.Builder()
                }
            )
        }
    }
}

struct DetailView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen
    @StateObject private var viewModel: DetailViewModel

    init(id: Int) {
        _viewModel = .init(wrappedValue: .init(id: id))
    }

    init(train: Train) {
        _viewModel = .init(wrappedValue: .init(train: train))
    }

    var body: some View {
        VStack {
            if let train = viewModel.train {
                Text(train.name)
                    .padding()
                Button(
                    action: {
                        navigator.go(
                            to: CapacityScreen(
                                capacity: train.capacity,
                                trainId: train.id
                            ),
                            on: currentScreen
                        )
                    },
                    label: { Text("Show capacity").foregroundColor(.red) }
                )
            } else {
                ProgressView()
            }
        }
        .navigationTitle(viewModel.train?.name ?? "Loading")
        .task {
            try? await viewModel.load()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(id: 1)
    }
}
