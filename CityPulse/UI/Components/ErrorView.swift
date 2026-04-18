import SwiftUI

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: WeatherIcon.warning)
                .font(.system(size: 64))
                .foregroundColor(Color.UI.textPrimary)
            Text("Error al cargar el clima")
                .foregroundColor(Color.UI.textPrimary)
                .font(.system(size: 18, weight: .bold))
            Text(message)
                .foregroundColor(Color.UI.textSecondary)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Spacer()
        }
    }
}
