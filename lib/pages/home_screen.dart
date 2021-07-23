import 'package:covid19/pages/all_country_info.dart';
import 'package:covid19/pages/navigation_items.dart';
import 'package:covid19/pages/states_wise_stats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.indigoAccent.shade400,),
        child: BottomNavigationBar(
          elevation: 5,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: TextStyle(color: Colors.white, fontSize: 12),
          onTap: (index){
            setState(() {
              debugPrint(index.toString());
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Image.asset(
                  'asset/stats.png',
                  height: 23,
                  color: _currentIndex==0?Colors.white:Colors.white70,
                ),
                label: 'Stats'),

            BottomNavigationBarItem(
                icon: Icon(
                  Icons.radio,
                  size: 25,
                  color: _currentIndex==1?Colors.white:Colors.white70,
                ),
                label: 'News'),
            BottomNavigationBarItem(
                icon: Image.asset(
                  'asset/global.png',
                  height: 23,
                  color: _currentIndex==2?Colors.white:Colors.white70,
                ),
                label: 'Country Stats'),
            BottomNavigationBarItem(
                icon: Image.asset(
                  'asset/india.png',
                  height: 25,
                  color: _currentIndex==3?Colors.white:Colors.white70,
                ),
                label: 'Indian States'),
          ],
        ),
      ),
      body: getBottomNavigationItem(_currentIndex),
    );
  }

  Widget getBottomNavigationItem(int i){

    switch(i){
      case 0:
        return Home();
      case 1:
        return Headlines();
      case 2:
        return TopCountry();
      default:
        return StatesInfo();

    }
  }
}
