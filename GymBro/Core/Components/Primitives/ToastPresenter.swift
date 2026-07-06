import Foundation
import Observation

/// Auto-dismissing transient toast. View models embed one and forward
/// `message` to their view's toast overlay; re-firing restarts the timer.
@Observable
final class ToastPresenter {

    private(set) var message: String? = nil

    @ObservationIgnored private var dismissTask: Task<Void, Never>? = nil

    func fire(_ message: String, duration: Duration = .seconds(1.8)) {
        dismissTask?.cancel()
        self.message = message
        dismissTask = Task { [weak self] in
            try? await Task.sleep(for: duration)
            guard let self, !Task.isCancelled else { return }
            self.message = nil
        }
    }
}
