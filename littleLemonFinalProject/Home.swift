import SwiftUI
import CoreData

struct Home: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color(.systemBackground)
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                HStack {
                    Spacer()
                    Button {
                        selectedTab = 1
                    } label: {
                        Image("ProfilePicture")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 38, height: 38)
                            .foregroundColor(Color("Primary1"))
                    }
                    .padding(.trailing, 16)
                }
            }
            .frame(height: 60)
            .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
            
            Divider()
            
            TabView(selection: $selectedTab) {
                
                Menu()
                    .tag(0)
                    .tabItem {
                        Label("Menu", systemImage: "fork.knife")
                    }
                
                Profile()
                    .tag(1)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
            .accentColor(Color("Primary1"))
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    Home()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
