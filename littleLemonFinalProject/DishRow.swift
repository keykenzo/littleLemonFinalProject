import SwiftUI

struct DishRow: View {
    let dish: Dish

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            VStack(alignment: .leading, spacing: 6) {
                Text(dish.title ?? "")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(dish.desc ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                Spacer()

                Text("$\(dish.price ?? "0.00")")
                    .font(.subheadline.bold())
                    .foregroundColor(Color("Primary1"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            
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
                        .padding(20)
                        .foregroundColor(.gray)
                default:
                    ProgressView()
                }
            }
            .frame(width: 90, height: 90)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.vertical, 10)
    }
}
