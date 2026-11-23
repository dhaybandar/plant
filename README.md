# Planto 🌱

![Uploading Planto_Poster_2-2.png…]()


Planto is a SwiftUI app that helps people keep track of their plants and receive watering reminders.

## About

An individual project built in 10 days as part of a coding challenge. I was given a ready-made UI design and implemented it fully in SwiftUI on my own.

## Features

- Add a plant with its room, light requirement, watering frequency, and water amount.
- Edit or delete an existing plant reminder.
- Mark a plant as watered for the current day.
- Track daily watering progress and see an all-done state.
- Receive local notifications for watering reminders.
- Supports Light Mode and Dark Mode automatically.
- Uses Liquid Glass on the add button for a modern iOS experience.

## Challenges & What I Learned

- **Matching the design exactly:** Translating a finished design into code meant paying close attention to spacing, colors, typography, and component details, so the final screens look like the original.
- **Duplicate notifications:** Two notifications appeared at the same time for the same reminder. The cause was that the code scheduled a system notification after 3 seconds and, at the same moment, also created an in-app banner with the identical message. I removed the duplicate banner and kept only the system notification, so each reminder shows once.
- **Light and Dark Mode:** The app follows the device's appearance setting, so I had to make sure the colors and UI look good in both modes instead of designing for only one.

## Architecture

The project follows a lightweight MVVM structure:

```text
MyApp/
├── Models/        # Plant model and option enums
├── ViewModels/    # PlantStore: state, persistence, and plant actions
├── Views/         # SwiftUI screens and reusable UI components
└── Services/      # Local notification handling
```

`PlantStore` is responsible for adding, updating, deleting, and toggling plants. It also saves the plant list locally.

## Data Models

- `Plant` is a `struct` representing a plant reminder.
- `Room`, `Light`, `WateringDays`, and `WaterAmount` are `enum` types that provide the selectable options in the app.

## Local Storage

Plant data is encoded as JSON and saved locally with `UserDefaults` under the key `plants_v1`.

The data remains after closing the app, but is removed when the app is deleted. It does not sync between devices.

## Notifications

The app uses `UserNotifications` for local watering reminders. The regular reminders follow the watering schedule you choose.

For testing purposes, the app also schedules a notification a few seconds after adding a plant, so you can see a reminder without waiting. When testing, add a plant and allow notification permission.

## Requirements

- Xcode 26 or later
- iOS 26 or later for the Liquid Glass experience

## Run the Project

1. Clone the repository.
2. Open `Untitled Project.xcodeproj` in Xcode.
3. Choose an iPhone simulator or a connected iPhone.
4. Press **Run** (`⌘R`).
5. Allow notifications when prompted.

## Built With

- Swift
- SwiftUI
- UserDefaults
- UserNotifications

## Author

[Dhay Bandar](https://github.com/dhaybandar)

