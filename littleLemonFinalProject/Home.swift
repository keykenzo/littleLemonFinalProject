import SwiftUI
import CoreData

struct Home: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                ZStack {
                    
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 44)

                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: Profile()) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color("Primary1"))
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 10)
                .background(Color(.systemBackground))

                Divider()

                
                Menu()
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    Home()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
