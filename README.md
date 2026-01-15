🚀 Features Overview
🔐 Authentication
Email & password login using Supabase Authentication
Session persistence across app launches
Secure logout

🏠 Home Screen
Quote of the Day displayed prominently
Daily quote changes automatically using date-based logic
Scrollable quote feed
Trending authors & popular tags
Search-ready UI structure

❤️ Favorites
Users can mark quotes as favorites
Favorites are reflected instantly across the app
Dedicated Favorites tab
MVVM-based shared state using EnvironmentObject

🎨 Quote Design Editor
Edit quote text
Change font size
Text alignment (left / center / right)
Background style selection
Square / Story format
Export:
Share as text
Share as image
Save designed quotes to backend

🔔 Daily Quote & Notifications (10 Marks)
Local Quote of the Day
Native iOS local notifications
User can:
Enable / disable daily inspiration
Choose preferred notification time
Notifications scheduled using UNUserNotificationCenter

🧭 Settings & Personalization
Profile section
Theme selection (Light / Dark / System)
Accent color picker
Font size preview
Notification preferences
Logout


🏗 Architecture
SwiftUI
MVVM architecture
State management using:
@State
@StateObject
@EnvironmentObject
Separation of concerns:
Views → UI only
ViewModels → business logic
Managers → notifications, widgets, quote logic
🛠 Tech Stack
Area	Technolog
UI	SwiftUI
Architecture	MVVM
Backend	Supabase
Authentication	Supabase Auth
Persistence	AppStorage, UserDefaults
Notifications	UserNotifications (iOS native)
Widgets	WidgetKit
Image Rendering	ImageRenderer (iOS 16+
