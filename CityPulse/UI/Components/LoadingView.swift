import SwiftUI

struct LoadingView: View {
    @State private var alpha = 0.3
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: WeatherIcon.globe)
                .font(.system(size: 64))
                .foregroundColor(Color.UI.textPrimary)
            Text("Cargando CityPulse...")
                .foregroundColor(Color.UI.textPrimary.opacity(alpha))
                .font(.system(size: 18, weight: .medium))
                .onAppear {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 1).repeatForever()) {
                            alpha = 1.0
                        }
                    }
                }
            Spacer()
        }
    }
}
