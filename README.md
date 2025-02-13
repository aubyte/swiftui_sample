# swiftui_sample
macOS SwiftUI demonstration project for job application purposes.

1. Steps to Run

- In Xcode select Product/Destination -> "My Mac (Designed for iPad)", or an iPad target (simulator/device).
- Run the project.



2. UI Elements

Main view is a split screen with a collapsible navigation sidebar and corresponding detailed views.
Default values for user/dates are set to return valid responses from the Aircover.ai server.
Demonstrates two use cases (execute in order):

  1. Authentication. Input fields for user/password, and a button to initiate authentication. Default values are for test login. The bottom of the view will display authentication info from valid response.

  2. Request Meetings. Input fields for start/end dates to specify a range. A button will initiate request to a "meeting" endpoint. The bottom of the view will display a numbered list of meetings. Each meeting can be expanded to reveal details.

NOTE: There are more data components is the Aircover.ai JSON API. This project is for demo purposes.



3. Project Structure

Code is organized as follows:

  1. API. Has struct definitions to decode JSON objects, and static functions to perform two main operations: authenticate and getMeetingInfo.

  2. Contexts (instances of observable objects). There are one UserContext object and many MeetingContext. User context is the primary controlling "view-model". It initiates/receives data from the "model", and drives UI updates/interaction.

  3. Views/subviews. There are a few of detailed views that bind to properties of observable objects.

  4. HTTP requests/responses are handled asyncronously.

  5. Minor resources.
