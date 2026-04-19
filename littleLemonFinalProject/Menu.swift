import SwiftUI
import CoreData

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var searchText       = ""
    @State private var selectedCategory = ""
    @State private var isLoading        = true
    
    let categories = ["starters", "mains", "desserts", "drinks"]
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    heroSection
                    
                    menuBreakdown
                    
                    Divider()
                    
                    if isLoading {
                        ProgressView("Fetching the menu...")
                            .padding(40)
                    } else {
                        MenuItemList(
                            predicate: buildPredicate(),
                            sortDescriptors: buildSortDescriptors()
                        )
                        .padding(.horizontal)
                    }
                }
            }
            .task {
                await fetchMenuIfNeeded()
            }
        }
    }
    
    var heroSection: some View {
        ZStack {
            Color("Primary1")
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Little Lemon")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .fontWeight(.bold)
                            .foregroundColor(Color("Primary2"))
                        
                        Text("Chicago")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                            .foregroundColor(.white.opacity(0.9))
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    
                    Image("HeroImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search ", text: $searchText)
                        .autocorrectionDisabled()
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
            }
            .padding(16)
        }
    }
    
    
    
    var menuBreakdown: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("ORDER FOR DELIVERY!")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 14)
                .padding(.bottom, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categories, id: \.self) { cat in
                        let isSelected = selectedCategory == cat
                        Button {
                            
                            selectedCategory = isSelected ? "" : cat
                        } label: {
                            Text(cat.capitalized)
                                .font(.subheadline.bold())
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(isSelected ? Color("Primary1") : Color.gray.opacity(0.15))
                                .foregroundColor(isSelected ? .white : Color("Primary1"))
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 14)
            }
        }
    }
    
    
    
    func buildPredicate() -> NSPredicate {
        let hasSearch   = !searchText.isEmpty
        let hasCategory = !selectedCategory.isEmpty
        
        switch (hasSearch, hasCategory) {
        case (false, false):
            return NSPredicate(value: true)
        case (true, false):
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        case (false, true):
            return NSPredicate(format: "category == %@", selectedCategory)
        case (true, true):
            return NSPredicate(
                format: "title CONTAINS[cd] %@ AND category == %@",
                searchText, selectedCategory
            )
        }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        [NSSortDescriptor(
            key: "title",
            ascending: true,
            selector: #selector(NSString.localizedStandardCompare)
        )]
    }
    
    
    
    func fetchMenuIfNeeded() async {
        let request: NSFetchRequest<Dish> = Dish.fetchRequest()
        let count = (try? viewContext.count(for: request)) ?? 0
        
        // Só busca na rede se o banco estiver vazio
        if count == 0 {
            await fetchMenuFromNetwork()
        }
        
        isLoading = false
    }
    
    func fetchMenuFromNetwork() async {
        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/refs/heads/main/menu.json"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded   = try JSONDecoder().decode(MenuList.self, from: data)
            
            await MainActor.run {
                for item in decoded.menu {
                    let dish      = Dish(context: viewContext)
                    dish.title    = item.title
                    dish.desc     = item.description
                    dish.price    = item.price
                    dish.image    = item.image
                    dish.category = item.category
                }
                try? viewContext.save()
            }
        } catch {
            print("Erro ao buscar cardápio: \(error)")
        }
    }
}



struct MenuItemList: View {
    @FetchRequest var dishes: FetchedResults<Dish>
    
    init(predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) {
        _dishes = FetchRequest(
            sortDescriptors: sortDescriptors,
            predicate: predicate,
            animation: .default
        )
    }
    
    var body: some View {
        LazyVStack(spacing: 0) {
            if dishes.isEmpty {
                Text("Nenhum item encontrado.")
                    .foregroundColor(.secondary)
                    .padding(40)
            } else {
                ForEach(dishes, id: \.self) { dish in
                    NavigationLink(destination: DishDetail(dish: dish)) {
                        DishRow(dish: dish)
                    }
                    .buttonStyle(.plain)
                    Divider()
                }
            }
        }
    }
}

struct MenuList: Decodable {
    let menu: [MenuItemNetwork]
}

struct MenuItemNetwork: Decodable {
    let id: Int
    let title: String
    let description: String
    let price: String
    let image: String
    let category: String
}
