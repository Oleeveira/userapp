import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:userapp/pages/home_page.dart';
import 'package:userapp/pages/legal_entities_profile_page.dart';
import 'package:userapp/pages/popup_menu_state.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentPageIndex = 0;
  List<Widget> body = [
    const HomePage(),
    const PopupMenuState(),
    const LegalEntitiesProfilePage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      
      currentPageIndex = index;
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
				currentIndex: currentPageIndex,
        onTap: onTabTapped,
        items: const [
           BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
            backgroundColor: Color.fromARGB(213, 66, 117, 165),
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.add, ),
            label: '',
            backgroundColor: Color.fromARGB(213, 66, 117, 165),
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
            backgroundColor: Color.fromARGB(213, 66, 117, 165),
          ),
        ],
      ),
    );
  }
}

 _optionsadd(context) {
   showModalBottomSheet(context: context, builder: (BuildContext bc){
    return Wrap(children: <Widget>[
    	        ListTile(
    	          leading:  const Icon(Icons.g_mobiledata_outlined),
    	          title:  const Text('Necessidade'),  iconColor: Colors.black,
    	          onTap: () => {GoRouter.of(context).go('/item_register_page')}, 
    	        ),
              ListTile(
    	          leading:  const Icon(Icons.facebook),
    	          title:  const Text('Visita'),  iconColor: Colors.black,
    	          onTap: () => {}, 
    	        ),
             ],
            );   
    }
  );
}