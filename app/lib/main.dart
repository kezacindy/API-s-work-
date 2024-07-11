import 'dart:async';
import 'package:battery/battery.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'homescreen.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
runApp(const MyApp());
}

class MyApp extends StatefulWidget {
const MyApp({super.key});
@override
MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
ThemeMode themeMode = ThemeMode.light;
final Battery _battery = Battery();
final Connectivity _connectivity = Connectivity();
StreamSubscription<ConnectivityResult>? _connectivitySubscription;

Locale _locale = const Locale('en');
List<Contact> _contacts = [];
XFile? _profileImage;

@override
void initState() {
super.initState();
initConnectivity();
initBattery();
_requestPermissions();
}

@override
void dispose() {
_connectivitySubscription?.cancel();
super.dispose();
}

Future<void> initConnectivity() async {
ConnectivityResult result = await _connectivity.checkConnectivity();
_checkStatus(result);
_connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
_checkStatus(result);
});
}

void _checkStatus(ConnectivityResult result) {
if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
Fluttertoast.showToast(msg: 'Internet Connected!');
} else {
Fluttertoast.showToast(msg: 'No Internet Connection!');
}
}

Future<void> initBattery() async {
_battery.onBatteryStateChanged.listen((BatteryState state) {
if (state == BatteryState.charging) {
_battery.batteryLevel.then((level) {
if (level >= 50) {
Fluttertoast.showToast(msg: 'Battery level is now $level%');
// Add your ringtone code here
}
});
}
});
}

Future<void> _requestPermissions() async {
var status = await Permission.contacts.status;
if (!status.isGranted) {
if (await Permission.contacts.request().isGranted) {
_fetchContacts();
} else {
Fluttertoast.showToast(msg: 'Permission denied');
}
} else {
_fetchContacts();
}
}

Future<void> _fetchContacts() async {
final Iterable<Contact> contacts = await ContactsService.getContacts();
setState(() {
_contacts = contacts.toList();
});
}

void _updateProfileImage(XFile image) {
setState(() {
_profileImage = image;
});
}

void _changeTheme(ThemeMode themeMode) {
setState(() {
this.themeMode = themeMode;
});
}

void _changeLanguage(Locale locale) {
setState(() {
_locale = locale;
});
}

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Calculator',
themeMode: themeMode,
locale: _locale,
localizationsDelegates: const [
// Add your localization delegates here
],
supportedLocales: const [
Locale('en'),
Locale('es'),
],
home: HomeScreen(
onThemeChanged: _changeTheme,
onLanguageChanged: _changeLanguage,
contacts: _contacts,
onUpdateProfileImage: _updateProfileImage,
profileImage: _profileImage,
),
);
}
}
