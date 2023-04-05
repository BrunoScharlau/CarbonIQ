# CarbonIQ

The Flutter project for our Google Solutions Challenge submission: a user friendly Carbon footprint calculator to help you understand how much impact you actually have and how you can effectively join the fight against climate change. The project is intended as a solution to the **UN Sustainable Development Goal 13: Climate Action**.

## Team members
- [Bruno Scharlau](https://github.com/BrunoScharlau), Freshman at the Technical University of Munich
- [Carl von Bonin](https://github.com/carl-vbn), Freshman at Columbia University
- [Konstantin Tzantchev](https://github.com/konstantintzt), Freshman at the University of California, Los Angeles

## Project structure

All the code can be found in the `lib` folder. The `main.dart` file is the entry point of the app.
The `main_menu` folder contains the code for the main menu, `registration` contains the code for the registration sequence that runs the first time someone opens the app, `survey` contains modular code to easily create short questionnaires (like the daily quiz/survey). `data` contains code useful for storing and processing data, with `carbon.dart` in particular being used to calculate equivalent carbon emissions from the user's answers.

Each of these folder contains a `*_view.dart` file that defines the main view widget of the feature and a `*_widgets.dart` that defines sub-widgets used by this view.

## How the app works
The app is designed to be as simple and intuitive as possible. The first time the app is opened, the user is asked to register. This is done by answering a few questions about their lifestyle and habits. Every day, the user is able to take a short survey that asks a few questions about what they did that day. The app then calculates the equivalent carbon emissions and displays them in an easy to understand way. A graph shows the evolution of the user's impact, a pie chart shows what factors contribute most to the user's carbon footprint and a collection of comparisons with intuitive metrics helps the user understand what their impact actually represents. A simple tip is also displayed to help the user reduce their emissions.

## How to run the app
The easiest way is to run the app as a web app. However, while running on the web, notifications will not work and data may not be properly saved between sessions.

To build the app for the web, ensure that you have flutter installed, open a terminal in the directory this repository was cloned into and run
```bash
flutter build web
flutter run -d chrome
```
This requires Google Chrome to be installed. Alternatively, replace `chrome` with the name of another Flutter-supported installed browser.

The app was developed for Android, so it is recommended to run it on an Android device. To build the app for Android, ensure that you have flutter installed and run
```bash
flutter build apk
```
The generated apk can be found in `build/app/outputs/flutter-apk/app-release.apk`.
It can either be installed on a device or ran in an emulator.

To run the app on an Android emulator, run
```bash
flutter emulators
flutter emulators --launch <emulator_id>
flutter run
```
And select the Android device you want to run the app in.

**Important**: To make testing and demoing easier, the app will first display a Demo Menu. Press the first button from the top to run the App normally, or select another mode for testing. (Note: the demo users are randomly generated and do not reflect the behavior of any real-world person).

## Data sources
The data used to calculate carbon emissions is taken from the following sources:
- [Bureau of Transportation Statistics](https://www.bts.gov/content/estimated-national-average-vehicle-emissions-rates-vehicle-vehicle-type-using-gasoline-and)
- [United States Environmental Protection Agency][1]
- [Massachusetts Institute of Technology](https://climate.mit.edu/ask-mit/are-electric-vehicles-definitely-better-climate-gas-powered-cars)
- [Oxford University Press](https://academic.oup.com/tse/article/1/2/164/5631920)
- [United States Department of Transportation](https://www.transit.dot.gov/sites/fta.dot.gov/files/docs/PublicTransportationsRoleInRespondingToClimateChange2010.pdf)
- [United States Energy Information Administration](https://www.eia.gov/tools/faqs/faq.php?id=74&t=11)
- [United Nations](https://www.un.org/en/actnow/ten-actions)
- [United States Department of Agriculture](https://www.usda.gov/media/blog/2015/03/17/power-one-tree-very-air-we-breathe)
- [International Energy Agency](https://www.iea.org/commentaries/the-world-s-top-1-of-emitters-produce-over-1000-times-more-co2-than-the-bottom-1)

## Open-source libraries used
The following open-source libraries are used by this application:
- `flutter` to create a multiplatform app from a single codebase
- `cupertino_icons` to embed simple and recognizable icons into the app
- `intl` to format dates
- `fl_chart` to generate charts

## Limits and future goals
Currently, the app only focuses on three core sectors of the user's carbon footprint: transportation, household electricity consumption and food consumption. While these are the most important sectors, there are many other factors that could influence the user's carbon footprint. Additionally, the app uses some data that is only relevant to US residents. In the future, we want to expand the app to include more varied questions and to make it more relevant to users from other countries.

[1]: https://nepis.epa.gov/Exe/ZyNET.exe/P100JPPH.TXT?ZyActionD=ZyDocument&Client=EPA&Index=2011+Thru+2015&Docs=&Query=&Time=&EndTime=&SearchMethod=1&TocRestrict=n&Toc=&TocEntry=&QField=&QFieldYear=&QFieldMonth=&QFieldDay=&IntQFieldOp=0&ExtQFieldOp=0&XmlQuery=&File=D%3A%5Czyfiles%5CIndex%20Data%5C11thru15%5CTxt%5C00000011%5CP100JPPH.txt&User=ANONYMOUS&Password=anonymous&SortMethod=h%7C-&MaximumDocuments=1&FuzzyDegree=0&ImageQuality=r75g8/r75g8/x150y150g16/i425&Display=hpfr&DefSeekPage=x&SearchBack=ZyActionL&Back=ZyActionS&BackDesc=Results%20page&MaximumPages=1&ZyEntry=1&SeekPage=x&ZyPURL
