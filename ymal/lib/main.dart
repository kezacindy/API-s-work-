import 'package:flutter/material.dart';


description: "A new Flutter project with internet connectivity detection."

publish_to: 'none'

version: 1.0.0+1

environment:
sdk: '>=3.4.3 <4.0.0'

dependencies:
flutter:
sdk: flutter
cupertino_icons: ^1.0.8
intl: ^0.19.0
shared_preferences: ^2.2.3
battery: ^2.0.3
connectivity: ^3.0.6
flutter_local_notifications: ^17.2.1

fluttertoast: ^8.0.8
rxdart: ^0.27.2
contacts_service: ^0.6.3
image_picker: ^0.8.4+3
permission_handler: ^10.4.0
flutter_localizations: # Add this line
sdk: flutter
file_picker: ^8.0.6
dev_dependencies:
flutter_test:
sdk: flutter
flutter_lints: ^4.0.0
intl_utils: ^2.4.1

flutter:
uses-material-design: true
assets:
- lib/assets/translations/
generate: true