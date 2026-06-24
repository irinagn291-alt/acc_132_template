import SwiftUI
import SwiftData

struct PetalStreakRow: View {
    let streak: Int
    let weekActivity: [Bool]

    var body: some View {
        SoftGlassCard {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(streak)")
                        .font(.system(size: 34, weight: .bold, design: .serif))
                        .foregroundStyle(BloomPalette.text)
                    Text(streak == 1 ? "day blooming" : "days blooming")
                        .font(.caption)
                        .foregroundStyle(BloomPalette.textMuted)
                }

                Spacer()

                HStack(spacing: 8) {
                    ForEach(weekActivity.indices, id: \.self) { index in
                        VStack(spacing: 4) {
                            PetalShape()
                                .fill(
                                    weekActivity[index]
                                        ? LinearGradient(colors: [BloomPalette.accent, BloomPalette.primary], startPoint: .top, endPoint: .bottom)
                                        : LinearGradient(colors: [BloomPalette.surface.opacity(0.5), BloomPalette.surface.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                                )
                                .frame(width: 14, height: 22)
                            Text(dayLabel(for: index))
                                .font(.system(size: 9, weight: .medium))
                                .foregroundStyle(BloomPalette.textMuted)
                        }
                    }
                }
            }
        }
    }

    private func dayLabel(for index: Int) -> String {
        let symbols = Calendar.current.shortWeekdaySymbols
        let todayIndex = Calendar.current.component(.weekday, from: .now) - 1
        let target = (todayIndex - (6 - index) + 7) % 7
        return String(symbols[target].prefix(1))
    }
}
