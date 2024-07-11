home_screen: :import 'package:flutter/material.dart';
import 'calculator.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contacts_service/contacts_service.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
final Function(ThemeMode) onThemeChanged;
final Function(Locale) onLanguageChanged;
final List<Contact> contacts;
final Function(XFile) onUpdateProfileImage;
final XFile? profileImage;

const HomeScreen({
Key? key,
required this.onThemeChanged,
required this.onLanguageChanged,
required this.contacts,
required this.onUpdateProfileImage,
this.profileImage,
}) : super(key: key);

@override
_HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
int _selectedIndex = 0;
bool _isDarkMode = false;
List<Widget> _screens = [];

@override
void initState() {
super.initState();
_screens = [
SignInScreen(isDarkMode: _isDarkMode),
SignUpScreen(isDarkMode: _isDarkMode),
const CalculatorScreen(),
];
}

void _onItemTapped(int index) {
setState(() {
_selectedIndex = index;
});
}

Future<void> _getImage(ImageSource source) async {
final pickedFile = await ImagePicker().pickImage(source: source);
if (pickedFile != null) {
widget.onUpdateProfileImage(pickedFile);
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Home Screen'),
actions: [
IconButton(
icon: const Icon(Icons.language),
onPressed: () {
widget.onLanguageChanged(_isDarkMode ? const Locale('en') : const Locale('es'));
},
),
],
),
body: _screens[_selectedIndex],
bottomNavigationBar: BottomNavigationBar(
items: const <BottomNavigationBarItem>[
BottomNavigationBarItem(
icon: Icon(Icons.login),
label: 'Sign In',
),
BottomNavigationBarItem(
icon: Icon(Icons.app_registration),
label: 'Sign Up',
),
BottomNavigationBarItem(
icon: Icon(Icons.calculate),
label: 'Calculator',
),
],
currentIndex: _selectedIndex,
selectedItemColor: Colors.amber[800],
onTap: _onItemTapped,
),
drawer: Drawer(
child: Container(
color: _isDarkMode ? Colors.grey[800] : Colors.white,
child: ListView(
padding: EdgeInsets.zero,
children: <Widget>[
DrawerHeader(
decoration: const BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topRight,
end: Alignment.bottomLeft,
colors: [Colors.blue, Colors.red],
),
),
child: Column(
children: [
const Text(
'Menu',
style: TextStyle(
color: Colors.white,
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
CircleAvatar(
radius: 40,
backgroundImage: widget.profileImage != null
? FileImage(File(widget.profileImage!.path))
: const AssetImage('assets/default_profile.png') as ImageProvider,
),
],
),
),
ListTile(
leading: const Icon(Icons.photo_library),
title: const Text('Select from Gallery'),
onTap: () {
_getImage(ImageSource.gallery);
},
),
ListTile(
leading: const Icon(Icons.camera_alt),
title: const Text('Take a Picture'),
onTap: () {
_getImage(ImageSource.camera);
},
),
ListTile(
title: const Text('Dark Mode'),
trailing: Switch(
value: _isDarkMode,
onChanged: (value) {
setState(() {
_isDarkMode = value;
_screens[0] = SignInScreen(isDarkMode: _isDarkMode);
_screens[1] = SignUpScreen(isDarkMode: _isDarkMode);
widget.onThemeChanged(value ? ThemeMode.dark : ThemeMode.light);
});
},
),
),
const Divider(),
ListTile(
leading: const Icon(Icons.contacts),
title: const Text('Contacts'),
onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => ContactsScreen(contacts: widget.contacts),
),
);
},
),
],
),
),
),
);
}
}

class ContactsScreen extends StatelessWidget {
final List<Contact> contacts;

const ContactsScreen({Key? key, required this.contacts}) : super(key: key);

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Contacts'),
),
body: ListView.builder(
itemCount: contacts.length,
itemBuilder: (context, index) {
final contact = contacts[index];
return ListTile(
title: Text(contact.displayName ?? 'No Name'),
subtitle: Text(contact.phones?.isNotEmpty == true
? contact.phones!.first.value!
: 'No Phone'),
);
},
),
);
}
}