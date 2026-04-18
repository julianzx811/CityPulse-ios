import SwiftUI

struct MapStatView: View {
    let icon: String
    let value: String
    let label: String
    let isNight: Bool
    
    var textColor: Color {
        isNight ? Color.Map.nightText : Color.Map.dayText
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(textColor)
            Text(value)
                .foregroundColor(textColor)
                .font(.system(size: 14, weight: .bold))
            Text(label)
                .foregroundColor(textColor.opacity(0.6))
                .font(.system(size: 11))
        }
        .frame(maxWidth: .infinity)
    }
}
