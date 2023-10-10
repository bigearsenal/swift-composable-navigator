import Foundation

final class CapacityViewModel: ObservableObject {
    // MARK: - Properties

    private let trainId: Int?

    // MARK: - Published properties

    @Published var capacity: Int?

    // MARK: - Initializer

    init(capacity: Int) {
        trainId = nil
        self.capacity = capacity
    }

    init(trainId: Int) {
        self.trainId = trainId
    }

    // MARK: - Methods

    func load() async throws {
        guard let trainId else { return }
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        await MainActor.run {
            capacity = trains.first(where: { $0.id == trainId })?.capacity
        }
    }
}
