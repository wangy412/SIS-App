//
//  SISAppWidget.swift
//  SISAppWidget
//
//  Created by Wang Yunze on 20/11/20.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), blocks: DataProvider.placeholderBlocks)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), blocks: DataProvider.placeholderBlocks)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries = [
            SimpleEntry(date: Date(), blocks: DataProvider.placeholderBlocks)
        ]
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let blocks: [Block]
}

struct SISAppWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Click to check in:")
            
            HStack {
                ForEach(0..<4) { i in
                    VStack {
                        Text(entry.blocks[i].shortName)
                            .minimumScaleFactor(0.01)
                            .lineLimit(
                                entry
                                    .blocks[i]
                                    .shortName
                                    .components(separatedBy: " ")
                                    .count
                            )
                            .foregroundColor(.white)
                            .padding(5)
                            .frame(width: 66, height: 66)
                            .background(
                                ContainerRelativeShape()
                                    .fill(Color.blue)
                            )
                    }
                }
            }
            .padding()
            .background(
                ContainerRelativeShape()
                    .fill(Color.green)
            )
        }
    }
}

@main
struct SISAppWidget: Widget {
    let kind: String = "SISAppWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SISAppWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("RI Safe Entry")
        .description("Check in / out easily with this widget")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct SISAppWidget_Previews: PreviewProvider {
    static var previews: some View {
        SISAppWidgetEntryView(entry: SimpleEntry(date: Date(), blocks: DataProvider.placeholderBlocks))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}