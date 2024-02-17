import 'package:flutter/material.dart';

import 'package:money_manager_flutter/screens/home/screen_home.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MoneyManagerBottomNavigation extends StatelessWidget {
  const MoneyManagerBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedIndexNotifier,
      builder: (BuildContext ctx, int updatedIndex, _) {
        //Used Gnav pachage for creating botton nav bar
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 55, vertical: 10),
              height: 60,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.green,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: GNav(
                  onTabChange: (value) {
                    ScreenHome.selectedIndexNotifier.value = value;
                  },
                  color: Colors.white,
                  //rippleColor: Colors.green,
                  tabBorderRadius: 40,
                  // tabActiveBorder: Border.all(color: Colors.black.withOpacity(.5), width: 2),
                  //tabBorder: Border.all(color: Colors.black.withOpacity(.5), width: 2),
                  tabBackgroundColor: Colors.white,
                  padding: const EdgeInsets.all(15),
                  gap: 50,
                  iconSize: 30,
                  tabs: const [
                    GButton(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      icon: Icons.receipt_long,
                      text: 'Transactions',
                    ),
                    GButton(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      icon: Icons.category,
                      text: 'Category',
                    )
                  ]),
            ),
          ],
        );
      },
    );
  }
}

// class GoogleBottonNavBar extends StatelessWidget {
//   const GoogleBottonNavBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const GNav(tabs: [
//       GButton(icon: Icons.receipt_long, text: 'Transactions',),
//       GButton(icon: Icons.category)

//     ]);
//   }
// }
