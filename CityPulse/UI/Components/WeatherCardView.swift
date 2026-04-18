import SwiftUI

struct WeatherCardView: View {
    let icon: String
    let value: String
    let label: String
    @State private var cardFloat: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(Color.UI.textPrimary)
            Text(value)
                .foregroundColor(Color.UI.textPrimary)
                .font(.system(size: 18, weight: .bold))
            Text(label)
                .foregroundColor(Color.UI.textSecondary)
                .font(.system(size: 12))
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.UI.cardBackground)
        .cornerRadius(20)
        .offset(y: cardFloat)
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever()) {
                cardFloat = 6
            }
        }
    }
}
