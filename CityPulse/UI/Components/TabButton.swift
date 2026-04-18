import SwiftUI

struct TabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
            }
            .foregroundColor(isSelected ? Color.UI.textPrimary : Color.UI.textMuted)
            .font(.system(size: 15, weight: isSelected ? .bold : .regular))
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(isSelected ? Color.UI.cardBackground : Color.clear)
            .cornerRadius(20)
        }
        Spacer()
    }
}
