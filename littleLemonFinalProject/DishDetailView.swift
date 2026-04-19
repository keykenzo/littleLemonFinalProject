import SwiftUI

struct DishDetail: View {
    let dish: Dish
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                
                AsyncImage(url: URL(string: dish.image ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "fork.knife")
                            .resizable()
                            .scaledToFit()
                            .padding(60)
                            .foregroundColor(.gray)
                    default:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 280)
                .background(Color.gray.opacity(0.1))
                .clipped()
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text(dish.title ?? "")
                        .font(.system(size: 26, weight: .bold, design: .serif))
                        .foregroundColor(.primary)
                    
                    Text("$\(dish.price ?? "0.00")")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .background(Color("Primary1"))
                        .clipShape(Capsule())
                    
                    Divider()
                    
                    Text("About this dish")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(dish.desc ?? "")
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineSpacing(5)
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(dish.title ?? "")
    }
}
