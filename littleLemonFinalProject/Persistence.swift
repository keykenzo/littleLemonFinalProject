import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "littleLemonFinalProject")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Erro ao carregar CoreData: \(error.localizedDescription)")
            }
        }
         
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
