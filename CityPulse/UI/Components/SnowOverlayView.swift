import SwiftUI

struct SnowOverlayView: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let offset = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 3.0) / 3.0
                
                let flakes: [(CGFloat, CGFloat)] = (0..<60).map { i in
                    let seed = Double(i) * 1.618
                    let x = CGFloat((seed * 9.3).truncatingRemainder(dividingBy: 100.0)) / 100.0
                    let startY = CGFloat((seed * 5.7).truncatingRemainder(dividingBy: 100.0)) / 100.0
                    return (x, startY)
                }
                
                for (x, startY) in flakes {
                    let y = (startY + CGFloat(offset)).truncatingRemainder(dividingBy: 1.0)
                    let flakeY = size.height * y
                    let alpha = Double(0.5 + (1.0 - y) * 0.5)
                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: size.width * x - 4,
                            y: flakeY - 4,
                            width: 8,
                            height: 8
                        )),
                        with: .color(.white.opacity(alpha))
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
}
