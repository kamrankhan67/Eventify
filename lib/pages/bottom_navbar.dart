import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:event_booking_app/pages/booking.dart';
import 'package:event_booking_app/pages/home_page.dart';
import 'package:event_booking_app/pages/profile.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late ProfilePage profile;
  late BookingPage booking;
  late HomePage home;

  @override
  void initState() {
    home = HomePage();
    booking = BookingPage();
    profile = ProfilePage();
    pages = [home, booking, profile];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        color: Colors.black,
        backgroundColor: Colors.white,
        height: 65,
        animationDuration: const Duration(milliseconds: 500),
        items: const [
          Icon(Icons.home, color: Colors.white, size: 30),
          Icon(Icons.book_outlined, color: Colors.white, size: 30),
          Icon(Icons.person_2_outlined, color: Colors.white, size: 30),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
