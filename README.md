# gretapp

The Flutter project for our Google Solutions Challenge submission.
*Gretapp is the project's codename as we don't have a final name for the app yet*

## Project structure

All the code can be found in the `lib` folder. The `main.dart` file is the entry point of the app.
The `main_menu` folder contains the code for the main menu, `registration` contains the code for the registration sequence that runs the first time someone opens the app, `survey` contains modular code to easily create short questionnaires (like the daily quiz/survey).

Each of these folder contains a `*_view.dart` file that defines the main view widget of the feature and a `*_widgets.dart` that defines sub-widgets used by this view.