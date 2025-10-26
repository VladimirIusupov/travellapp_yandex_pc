import SwiftUI

// MARK: - View
struct CarrierCardView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = CarriersViewModel()
    let carrierCode: String
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 22)
                        .foregroundStyle(.primary)
                }
                Spacer()
                Text("Информация о перевозчике")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.primary)
                Spacer()
                Color.clear.frame(width: 17, height: 22)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            if viewModel.isLoading {
                Spacer()
                ProgressView("Загрузка…")
                Spacer()
            } else if let appError = viewModel.appError {
                Spacer()
                ErrorView(type: appError.errorType)
                Spacer()
            } else if let carrier = viewModel.carrier {
                ScrollView {
                    VStack(spacing: 0) {
                        if let logo = carrier.logo, let url = URL(string: logo) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                                
                            } placeholder: {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                            }
                            .padding(.top, 16)
                            .padding(.horizontal, 16)
                        }
                        
                        Text(carrier.title ?? "Без названия")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 16)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 28)
                        
                        VStack(alignment: .leading, spacing: 24) {
                            if let email = carrier.email {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("E-mail")
                                        .font(.system(size: 15, weight: .semibold))
                                    Link(email, destination: URL(string: "mailto:\(email)")!)
                                        .font(.system(size: 15))
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            if let phone = carrier.phone {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Телефон")
                                        .font(.system(size: 15, weight: .semibold))
                                    Link(phone, destination: URL(string: "tel:\(phone)")!)
                                        .font(.system(size: 15))
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        
                        Spacer()
                    }
                    .padding(.top, 24)
                }
            } else {
                Spacer()
                Text("Вариантов нет")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.ypWhite)
                Spacer()
            }
        }
        .background(Color(.ypWhite).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.loadCarrier(code: carrierCode)
        }
    }
}
