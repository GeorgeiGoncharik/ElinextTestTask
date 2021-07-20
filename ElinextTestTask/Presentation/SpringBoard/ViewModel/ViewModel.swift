import Foundation
import Combine

final class ViewModel: ObservableObject {
    @Published var models = Array(0..<140).map { _ in Model() }
    
    func reloadAll() {
        models = Array(0..<140).map { _ in Model() }
    }
    
    func addOne() {
        models.append(Model())
    }
}
