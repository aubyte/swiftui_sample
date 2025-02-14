# swiftui_sample
iOS/macOS SwiftUI demonstration project (showcases SwiftUI and RESTful API).

![Screenshot 2025-02-13 at 6 07 07 PM](https://github.com/user-attachments/assets/90586572-bc91-4598-a028-fc510869464c)

![Screenshot 2025-02-13 at 6 06 50 PM](https://github.com/user-attachments/assets/2a975d57-9444-4f32-bdf9-6c8e49998761)

![Screenshot 2025-02-13 at 6 08 30 PM](https://github.com/user-attachments/assets/1eb3a617-6a9b-4c19-bcd9-1fb59a5cc06f)



1. Steps to Run

- In Xcode select Product/Destination -> "My Mac (Designed for iPad)", or an iPad target (simulator/device).
- Run the project.




2. UI Elements

Main view is a split screen with a collapsible navigation sidebar and corresponding detailed views.
Default values for user/dates are set to return valid responses from the Aircover.ai server (well, ask me for password, or just figure it out on your own).
The app demonstrates two use cases:

  1. Authentication. Input fields for user/password, and a button to initiate authentication. On successful response, the bottom of the view will display authentication info.

  2. Request Meetings. Input fields for start/end dates to specify a range. A button will initiate request to a "meeting" endpoint. The bottom of the view will display a numbered list of meetings. Each meeting can be expanded to reveal its details.

NOTE: There are more data components defined is the Aircover.ai API. This project is limited for demonstration purpose.




3. Project Structure

Code is organized as follows:

  1. API. Has struct definitions to decode JSON objects, and functions to perform requests.

  2. Contexts (instances of observable objects). There are one UserContext object and many MeetingContext. User context is the primary controlling "view-model". It initiates/receives data from the "model", and drives UI updates/interaction.

  3. Views/subviews. There are a few additional views that bind to properties of observable objects.

  4. HTTP requests/responses are handled asyncronously.

  5. Some minor resources.
