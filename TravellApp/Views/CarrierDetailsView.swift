import SwiftUI

struct CarrierDetailsView: View, Identifiable {
    let id = UUID()
    let item: CarrierItem

    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer()
                    Image(systemName: item.logoSystemName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 64)
                        .foregroundStyle(.red)
                    Spacer()
                }
                Text("ОАО «\(item.name)»").font(.title3).bold()
                VStack(alignment: .leading, spacing: 8) {
                    Text("E-mail").font(.caption).foregroundStyle(.secondary)
                    Link("login@yandex.ru", destination: URL(string: "mailto:login@yandex.ru")!)
                    Text("Телефон").font(.caption).foregroundStyle(.secondary).padding(.top, 8)
                    Link("+7 (904) 232-27-71", destination: URL(string: "tel:+79042322771")!)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
    }
}
