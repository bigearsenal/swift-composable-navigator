import ComposableNavigator
import SwiftUI

struct CapacityScreen: Screen {
    let capacity: Int?
    let trainId: Int?
    var presentationStyle: ScreenPresentationStyle = .sheet(
        allowsPush: false,
        presentationDetent: [.fraction(2.0 / 3)]
    )

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen { (screen: CapacityScreen) in
                if let capacity = screen.capacity {
                    CapacityView(capacity: capacity)
                } else if let trainId = screen.trainId {
                    CapacityView(trainId: trainId)
                } else {
                    EmptyView()
                }
            }
        }
    }
}

struct CapacityView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    @StateObject private var viewModel: CapacityViewModel

    init(capacity: Int) {
        _viewModel = .init(wrappedValue: .init(capacity: capacity))
    }

    init(trainId: Int) {
        _viewModel = .init(wrappedValue: .init(trainId: trainId))
    }

    var body: some View {
        VStack {
            Image(systemName: "person.3.fill")
                .imageScale(.medium)
                .padding(.bottom)
            if let capacity = viewModel.capacity {
                Text("\(capacity)")
                    .font(.largeTitle)
                    .bold()
            } else {
                ProgressView()
            }
        }
        .navigationBarItems(
            trailing: Button(
                action: { navigator.dismiss(screen: currentScreen) },
                label: { Image(systemName: "xmark") }
            )
        )
        .navigationTitle(Text("Capacity"))
        .task {
            try? await viewModel.load()
        }
    }
}

struct CapacityView_Previews: PreviewProvider {
    static var previews: some View {
        CapacityView(capacity: 101)
    }
}
