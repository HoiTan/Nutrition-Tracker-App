// NutriAIWidgets.swift

import WidgetKit
import SwiftUI

// This defines the data for your widget.
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

// This is the data model for our simple widget.
struct SimpleEntry: TimelineEntry {
    let date: Date
}

// This is the SwiftUI view for the widget.
struct FoodLogWidgetsEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {
        switch family {
        case .accessoryCircular:
            // This is the view for the circular Lock Screen widget
            Image(systemName: "camera.viewfinder")
                .font(.title3)
        default:
            // This is the view for the Home Screen widgets
            VStack(spacing: 10) {
                Image(systemName: "camera.viewfinder")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                Text("Scan Meal")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

// This is the main widget configuration.
struct FoodLogWidgets: Widget {
    let kind: String = "FoodLogWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FoodLogWidgetsEntryView(entry: entry)
                .widgetURL(URL(string: "foodlog://scanmeal"))
                .containerBackground(for: .widget) {
                    Color.clear
                }
        }
        .configurationDisplayName("Quick Scan")
        .description("Tap to open the camera and log your meal.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular])
    }
}
