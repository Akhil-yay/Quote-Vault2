//
//  QuoteofTheDayWidgetLiveActivity.swift
//  QuoteofTheDayWidget
//
//  Created by Manish Rawat on 15/01/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct QuoteofTheDayWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct QuoteofTheDayWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: QuoteofTheDayWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension QuoteofTheDayWidgetAttributes {
    fileprivate static var preview: QuoteofTheDayWidgetAttributes {
        QuoteofTheDayWidgetAttributes(name: "World")
    }
}

extension QuoteofTheDayWidgetAttributes.ContentState {
    fileprivate static var smiley: QuoteofTheDayWidgetAttributes.ContentState {
        QuoteofTheDayWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: QuoteofTheDayWidgetAttributes.ContentState {
         QuoteofTheDayWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: QuoteofTheDayWidgetAttributes.preview) {
   QuoteofTheDayWidgetLiveActivity()
} contentStates: {
    QuoteofTheDayWidgetAttributes.ContentState.smiley
    QuoteofTheDayWidgetAttributes.ContentState.starEyes
}
