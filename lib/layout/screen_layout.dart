import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/screens/bookings_screen.dart';
import 'package:impeccablehome_helper/screens/chat_screen.dart';
import 'package:impeccablehome_helper/screens/home_screen.dart';
import 'package:impeccablehome_helper/screens/notification_screen.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';

class ScreenLayout extends StatefulWidget {
  final int initialIndex;

  const ScreenLayout({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _ScreenLayoutState createState() => _ScreenLayoutState();
}

class _ScreenLayoutState extends State<ScreenLayout> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, String>> _tabs = [
    {
      'label': 'Home',
      'activeIcon': 'assets/icons/home_active_icon.png',
      'inactiveIcon': 'assets/icons/home_inactive_icon.png',
    },
    {
      'label': 'Bookings',
      'activeIcon': 'assets/icons/bookings_active_icon.png',
      'inactiveIcon': 'assets/icons/bookings_inactive_icon.png',
    },
    {
      'label': 'Chat',
      'activeIcon': 'assets/icons/chat_active_icon.png',
      'inactiveIcon': 'assets/icons/chat_inactive_icon.png',
    },
    {
      'label': 'Notifications',
      'activeIcon': 'assets/icons/notifications_active_icon.png',
      'inactiveIcon': 'assets/icons/notifications_inactive_icon.png',
    },
  ];

  // final List<Widget> _screens = [
  //   HomeScreen(
  //     openEndDrawer: () {
  //       Scaffold.of(context).openEndDrawer();
  //     },
  //   ),
  //   BookingsScreen(),
  //   Center(child: Text('Chat Screen')),
  //   Center(child: Text('Notifications Screen')),
  // ];

  // @override
  // void initState() {
  //   super.initState();
  //   _currentIndex = widget.initialIndex;
  // }

  // @override
  // Widget build(BuildContext context) {
  //   final screenWidth = MediaQuery.of(context).size.width;

  //   return Scaffold(
  //     body: _screens[_currentIndex],
  //     endDrawer: CustomDrawer(
  //       username: "John Doe",
  //       avatarUrl: "https://example.com/avatar.jpg", // Replace with a real URL
  //     ),
  //     bottomNavigationBar: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         // Tab bar indicator with animation
  //         Container(
  //           alignment: Alignment.centerLeft,
  //           child: AnimatedContainer(
  //             duration: const Duration(milliseconds: 300),
  //             curve: Curves.easeInOut,
  //             height: 4,
  //             width: 40,
  //             color: skyBlueColor,
  //             margin: EdgeInsets.only(
  //               left: (screenWidth / _tabs.length) * _currentIndex +
  //                   (screenWidth / _tabs.length - 40) /
  //                       2, // Center the indicator
  //             ),
  //           ),
  //         ),
  //         // Bottom navigation bar
  //         BottomNavigationBar(
  //           currentIndex: _currentIndex,
  //           onTap: (index) {
  //             setState(() {
  //               _currentIndex = index;
  //             });
  //           },
  //           type: BottomNavigationBarType.fixed,
  //           selectedFontSize: 14,
  //           unselectedFontSize: 14,
  //           showSelectedLabels: true,
  //           showUnselectedLabels: true,
  //           items: _tabs.map((tab) {
  //             int tabIndex = _tabs.indexOf(tab);
  //             bool isSelected = tabIndex == _currentIndex;
  //             return BottomNavigationBarItem(
  //               icon: Column(
  //                 children: [
  //                   Image.asset(
  //                     isSelected ? tab['activeIcon']! : tab['inactiveIcon']!,
  //                     height: 24,
  //                     width: 24,
  //                   ),
  //                   Text(
  //                     tab['label']!,
  //                     style: TextStyle(
  //                       color: isSelected ? skyBlueColor : silverGrayColor,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               label: '',
  //             );
  //           }).toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  final List<Widget> _screens = []; // Declare it as empty initially.

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Populate _screens in build method where context is available
    final _screens = [
      HomeScreen(),
      BookingsScreen(),
      ChatScreen(),
      NotificationScreen(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      body: _screens[_currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tab bar indicator with animation
          Container(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 4,
              width: 40,
              color: skyBlueColor,
              margin: EdgeInsets.only(
                left: (screenWidth / _tabs.length) * _currentIndex +
                    (screenWidth / _tabs.length - 40) /
                        2, // Center the indicator
              ),
            ),
          ),
          // Bottom navigation bar
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: _tabs.map((tab) {
              int tabIndex = _tabs.indexOf(tab);
              bool isSelected = tabIndex == _currentIndex;
              return BottomNavigationBarItem(
                icon: Column(
                  children: [
                    Image.asset(
                      isSelected ? tab['activeIcon']! : tab['inactiveIcon']!,
                      height: 24,
                      width: 24,
                    ),
                    Text(
                      tab['label']!,
                      style: TextStyle(
                        color: isSelected ? skyBlueColor : silverGrayColor,
                      ),
                    ),
                  ],
                ),
                label: '',
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
