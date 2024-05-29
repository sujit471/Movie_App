import'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import '../Favorites/fav.dart';
import '../Liked/liked.dart';
import '../homepage/homepage.dart';
import '../profile/profile.dart';
import '../savedliked.dart';


class NavigationMenu extends StatelessWidget {
  NavigationMenu({Key? key,  }) : super(key: key);

  @override
  Widget build(BuildContext) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
            ()=> NavigationBar(
              backgroundColor: Colors.black,
          height : 80,
          elevation :0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index)=>controller.selectedIndex.value=index,
          destinations:const [
            NavigationDestination(icon: Icon(Iconsax.home,color: Colors.white,), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.trend_up,color: Colors.white,), label: 'Trending'),
            NavigationDestination(icon: Icon(Iconsax.user,color: Colors.white,), label: 'Profile'),


          ],

        ),
      ),

      body:Obx (()=>controller.screens[controller.selectedIndex.value]),
    );
  }
}
class NavigationController extends GetxController{


  final Rx<int> selectedIndex = 0.obs;
  //final screens =[ HomePage(), const FavoritesPage(),  Liked(likedImages: [],),const Profile()];
  final List<Widget>screens =[ HomePage(), const FavoritesPage(), const Profile()];
}
