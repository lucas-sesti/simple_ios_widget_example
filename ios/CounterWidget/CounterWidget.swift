//
//  CounterWidget.swift
//  CounterWidget
//
//  Created by Lucas Sesti on 05/11/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), counter: "0")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), counter: "0")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let counter = StorageHelper.getString(key: "counter") ?? "0"
        let entry = SimpleEntry(date: Date(), counter: counter)
        let timeline = Timeline(entries: [entry], policy: .never)
        
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let counter: String
}

struct CounterWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        Text("Counter: \(entry.counter)")
            .font(.headline)
    }
}

struct CounterWidget: Widget {
    let kind: String = "CounterWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                CounterWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CounterWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    CounterWidget()
} timeline: {
    SimpleEntry(date: .now, counter: "1")
    SimpleEntry(date: .now, counter: "2")
}
