import Foundation

final class DetailViewModel: ObservableObject {
    // MARK: - Properties

    private let id: Int

    // MARK: - Published properties

    @Published var train: Train?

    // MARK: - Initializer

    init(id: Int) {
        self.id = id
    }

    init(train: Train) {
        id = train.id
        self.train = train
    }

    // MARK: - Methods

    func load() async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        train = trains.first(where: { $0.id == id })
    }
}
