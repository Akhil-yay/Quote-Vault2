//
//  QuoteofTheDayWidgetBundle.swift
//  QuoteofTheDayWidget
//
//  Created by Manish Rawat on 15/01/26.
//

import WidgetKit
import SwiftUI

@main
struct QuoteofTheDayWidgetBundle: WidgetBundle {
    var body: some Widget {
        QuoteofTheDayWidget()
        QuoteofTheDayWidgetControl()
        QuoteofTheDayWidgetLiveActivity()
    }
}
