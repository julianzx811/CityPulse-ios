import SwiftUI

struct WeatherAnimationView: View {
    let weatherMain: String
    
    var body: some View {
        switch weatherMain.lowercased() {
        case "clear":
            SunAnimationView()
        case "clouds":
            CloudAnimationView()
        case "rain", "drizzle":
            RainAnimationView()
        case "thunderstorm":
            ThunderstormAnimationView()
        case "snow":
            SnowAnimationView()
        default:
            SunAnimationView()
        }
    }
}

struct SunAnimationView: View {
    @State private var rotation = 0.0
    @State private var pulse = 0.9
    
    var body: some View {
        Canvas { context, size in
            let cx = size.width / 2
            let cy = size.height / 2
            let radius = min(size.width, size.height) * 0.28 * pulse
            
            let haloPath = Path(ellipseIn: CGRect(
                x: cx - radius * 1.8,
                y: cy - radius * 1.8,
                width: radius * 3.6,
                height: radius * 3.6
            ))
            context.fill(haloPath, with: .color(.yellow.opacity(0.2)))
            
            for i in 0..<8 {
                let angle = (rotation + Double(i) * 45.0) * .pi / 180
                let startR = radius * 1.2
                let endR = radius * 1.6
                var ray = Path()
                ray.move(to: CGPoint(x: cx + startR * cos(angle), y: cy + startR * sin(angle)))
                ray.addLine(to: CGPoint(x: cx + endR * cos(angle), y: cy + endR * sin(angle)))
                context.stroke(ray, with: .color(.yellow.opacity(0.8)), lineWidth: 4)
            }
            
            let shadowPath = Path(ellipseIn: CGRect(
                x: cx - radius + radius * 0.15,
                y: cy - radius + radius * 0.15,
                width: radius * 2,
                height: radius * 2
            ))
            context.fill(shadowPath, with: .color(.orange.opacity(0.3)))
            
            let sunPath = Path(ellipseIn: CGRect(
                x: cx - radius, y: cy - radius,
                width: radius * 2, height: radius * 2
            ))
            context.fill(sunPath, with: .color(.yellow))
            
            let shinePath = Path(ellipseIn: CGRect(
                x: cx - radius * 0.6, y: cy - radius * 0.6,
                width: radius * 0.7, height: radius * 0.7
            ))
            context.fill(shinePath, with: .color(.white.opacity(0.35)))
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
                withAnimation(.easeInOut(duration: 1.5).repeatForever()) {
                    pulse = 1.1
                }
            }
        }
    }
}

struct CloudAnimationView: View {
    @State private var offsetX = -10.0
    
    var body: some View {
        Canvas { context, size in
            let cx = size.width / 2 + offsetX
            let cy = size.height / 2
            let r = min(size.width, size.height) * 0.18
            
            func circle(_ x: Double, _ y: Double, _ radius: Double) -> Path {
                Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            }
            
            context.fill(circle(cx, cy + r * 0.3, r * 2.5), with: .color(.gray.opacity(0.2)))
            
            let cloudColor = Color(red: 0.94, green: 0.95, blue: 0.96)
            context.fill(circle(cx - r, cy, r * 1.1), with: .color(cloudColor))
            context.fill(circle(cx, cy - r * 0.3, r * 1.4), with: .color(cloudColor))
            context.fill(circle(cx + r, cy, r * 1.1), with: .color(cloudColor))
            context.fill(circle(cx - r * 1.8, cy + r * 0.3, r * 0.9), with: .color(cloudColor))
            context.fill(circle(cx + r * 1.8, cy + r * 0.3, r * 0.9), with: .color(cloudColor))
            context.fill(Path(CGRect(x: cx - r * 2.5, y: cy, width: r * 5, height: r * 1.2)), with: .color(cloudColor))
            context.fill(circle(cx - r * 0.5, cy - r * 0.8, r * 0.5), with: .color(.white.opacity(0.4)))
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 3).repeatForever()) {
                    offsetX = 10
                }
            }
        }
    }
}

struct RainAnimationView: View {
    @State private var rainOffset = 0.0
    
    var body: some View {
        Canvas { context, size in
            let cx = size.width / 2
            let cy = size.height / 2
            let r = min(size.width, size.height) * 0.18
            let cloudColor = Color(red: 0.69, green: 0.77, blue: 0.84)
            
            func circle(_ x: Double, _ y: Double, _ radius: Double) -> Path {
                Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            }
            
            context.fill(circle(cx - r, cy, r * 1.1), with: .color(cloudColor))
            context.fill(circle(cx, cy - r * 0.3, r * 1.4), with: .color(cloudColor))
            context.fill(circle(cx + r, cy, r * 1.1), with: .color(cloudColor))
            context.fill(Path(CGRect(x: cx - r * 2.5, y: cy, width: r * 5, height: r * 1.2)), with: .color(cloudColor))
            
            let drops: [CGFloat] = [0.2, 0.4, 0.6, 0.8, 0.3, 0.5, 0.7]
            for (i, x) in drops.enumerated() {
                let y = (rainOffset + Double(i) * 0.15).truncatingRemainder(dividingBy: 1.0)
                let dropY = size.height * 0.55 + y * size.height * 0.4
                var drop = Path()
                drop.move(to: CGPoint(x: size.width * x, y: dropY))
                drop.addLine(to: CGPoint(x: size.width * x - 4, y: dropY + 20))
                context.stroke(drop, with: .color(.blue.opacity(1 - y)), lineWidth: 2)
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: false)) {
                    rainOffset = 1
                }
            }
        }
    }
}

struct ThunderstormAnimationView: View {
    @State private var flash = 0.0
    
    var body: some View {
        Canvas { context, size in
            let cx = size.width / 2
            let cy = size.height / 2
            let r = min(size.width, size.height) * 0.18
            let cloudColor = Color(red: 0.27, green: 0.35, blue: 0.39)
            
            func circle(_ x: Double, _ y: Double, _ radius: Double) -> Path {
                Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
            }
            
            context.fill(circle(cx - r, cy, r * 1.1), with: .color(cloudColor))
            context.fill(circle(cx, cy - r * 0.3, r * 1.4), with: .color(cloudColor))
            context.fill(circle(cx + r, cy, r * 1.1), with: .color(cloudColor))
            context.fill(Path(CGRect(x: cx - r * 2.5, y: cy, width: r * 5, height: r * 1.2)), with: .color(cloudColor))
            
            let alpha = flash > 0.8 ? 1.0 : 0.3
            var bolt = Path()
            bolt.move(to: CGPoint(x: cx + 10, y: cy + 20))
            bolt.addLine(to: CGPoint(x: cx - 10, y: cy + 55))
            bolt.addLine(to: CGPoint(x: cx + 5, y: cy + 55))
            bolt.addLine(to: CGPoint(x: cx - 15, y: cy + 100))
            bolt.addLine(to: CGPoint(x: cx + 20, y: cy + 58))
            bolt.addLine(to: CGPoint(x: cx + 5, y: cy + 58))
            bolt.closeSubpath()
            context.fill(bolt, with: .color(.yellow.opacity(alpha)))
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 2).repeatForever()) {
                    flash = 1
                }
            }
        }
    }
}

struct SnowAnimationView: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let offset = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 2.0) / 2.0
                let cx = size.width / 2
                let cy = size.height / 2
                let r = min(size.width, size.height) * 0.18
                let cloudColor = Color(red: 0.94, green: 0.95, blue: 0.96)
                
                func circle(_ x: Double, _ y: Double, _ radius: Double) -> Path {
                    Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
                }
                
                context.fill(circle(cx - r, cy, r * 1.1), with: .color(cloudColor))
                context.fill(circle(cx, cy - r * 0.3, r * 1.4), with: .color(cloudColor))
                context.fill(circle(cx + r, cy, r * 1.1), with: .color(cloudColor))
                context.fill(Path(CGRect(x: cx - r * 2.5, y: cy, width: r * 5, height: r * 1.2)), with: .color(cloudColor))
                
                let flakes: [(CGFloat, CGFloat)] = [
                    (0.2, 0.0), (0.35, 0.2), (0.5, 0.4),
                    (0.65, 0.6), (0.8, 0.8), (0.27, 0.1),
                    (0.45, 0.3), (0.72, 0.5), (0.15, 0.7)
                ]
                
                for (x, startOffset) in flakes {
                    let y = (CGFloat(offset) + startOffset).truncatingRemainder(dividingBy: 1.0)
                    let flakeY = size.height * 0.55 + y * size.height * 0.4
                    context.fill(circle(size.width * x, flakeY, 5), with: .color(.white.opacity(1 - y)))
                }
            }
        }
    }
}
