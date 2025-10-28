import SwiftUI

// MARK: - View
struct SegmentCard: View {
    
    @ObservedObject var viewModel: CarrierDetailsViewModel
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8).fill(Color.clear)
                    if let url = viewModel.logoURL {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 38, height: 38)
                        } placeholder: {
                            ProgressView().frame(width: 38, height: 38)
                        }
                    } else {
                        Image(systemName: viewModel.transportIcon)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.secondary)
                            .frame(width: 38, height: 38)
                    }
                }
                .frame(width: 38, height: 38)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(viewModel.carrierTitle)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    
                    if let transfers = viewModel.hasTransfersText {
                        Text(transfers)
                            .font(.system(size: 12))
                            .foregroundStyle(.red)
                    }
                }
                
                Spacer()
                
                if let depDate = viewModel.departureDateText {
                    Text(depDate)
                        .font(.system(size: 12))
                        .foregroundStyle(.black)
                }
            }
            
            HStack {
                if let depTime = viewModel.departureTimeText {
                    Text(depTime)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                }
                
                ZStack {
                    Capsule()
                        .fill(.ypGrey)
                        .frame(height: 1)
                    
                    if let duration = viewModel.durationText {
                        Text(duration)
                            .font(.system(size: 12))
                            .foregroundStyle(.black)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 3)
                            .background(.ypLightGrey)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                
                if let arrTime = viewModel.arrivalTimeText {
                    Text(arrTime)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                }
            }
            .frame(height: 40)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ypLightGrey)
                .frame(height: 104)
        )
    }
}
