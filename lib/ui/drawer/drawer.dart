import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mao/provider/drawerprovider.dart';
import 'package:provider/provider.dart';



class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int _selectedIndex=-1;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        padding: const  EdgeInsets.all(0),
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 32.0),
              color: Colors.white,
              child: Column(children: [
                CircleAvatar(
                  minRadius: 40,
                  backgroundColor: Colors.pink.shade300,
                  child: const Text(
                    "A",
                    style: TextStyle(fontSize: 30.0, color: Colors.blue),
                  ),
                ),
                const Text( "Avecsage"),
                const Text("Avecsage@gmail.com"),
              ]),
            ),
          buildListTile(0,context,Icons.home, 'Home'),
          buildListTile(1,context,FontAwesomeIcons.squarePollVertical, 'Trip History'),
          buildListTile(2,context,Icons.person, 'Profile'),
          buildListTile(3,context,Icons.favorite, 'Reports'),
          buildListTile(4,context,FontAwesomeIcons.briefcase, 'Status'),
          buildListTile(5,context,Icons.settings, 'Settings'),
        ],
      ),
    );

  }

  ListTile buildListTile(int index,BuildContext context,IconData icon, String title) {
    _selectedIndex=Provider.of<PageChange>(context).pageIndex;
    return ListTile(
      tileColor: _selectedIndex == index ? Colors.pink.withOpacity(0.2) : null,
      leading: Icon(icon
      ,color: _selectedIndex == index ?Colors.pink:null),
      title: Text(title),
      trailing:  Icon(_selectedIndex == index ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight
      ,size: 18
      ,color: _selectedIndex == index ?Colors.pink:null,),
      onTap: () {
         Provider.of<PageChange>(context,listen:false).changePage(index);
        Navigator.pop(context);
       },
    );
  }
}

