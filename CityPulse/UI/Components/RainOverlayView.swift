import SwiftUI

struct RainOverlayView: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let offset = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 1.0)
                
                let drops: [(CGFloat, CGFloat, CGFloat)] = (0..<80).map { i in
                    let seed = Double(i) * 1.618
                    let x = CGFloat((seed * 13.7).truncatingRemainder(dividingBy: 100.0)) / 100.0
                    let startY = CGFloat((seed * 7.3).truncatingRemainder(dividingBy: 100.0)) / 100.0
                    let speed = CGFloat(0.5 + (seed * 3.1).truncatingRemainder(dividingBy: 0.8))
                    return (x, startY, speed)
                }
                
                for (x, startY, speed) in drops {
                    let y = (startY + CGFloat(offset) * speed).truncatingRemainder(dividingBy: 1.0)
                    let alpha = Double(0.3 + speed * 0.3)
                    var drop = Path()
                    drop.move(to: CGPoint(x: size.width * x, y: size.height * y))
                    drop.addLine(to: CGPoint(x: size.width * x - 2, y: size.height * y + 18))
                    context.stroke(drop, with: .color(.blue.opacity(alpha)), lineWidth: 2)
                }
            }
        }
        .allowsHitTesting(false)
    }
}
