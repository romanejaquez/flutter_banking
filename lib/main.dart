import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tab_sample/pages/splashpage.dart';
import 'package:tab_sample/utils/utils.dart';
import 'colors.dart';

void main() {
  runApp(
    MaterialApp(
        navigatorKey: Singleton.mainNav,
        theme: ThemeData(fontFamily: 'ProductSansRegular'),
        debugShowCheckedModeBanner: false,
        initialRoute: "/splash",
        routes: {
          '/splash': (context) => SplashPage(duration: 2, goToPage: '/myapp'),
          "/": (BuildContext context) => MainApp(),
          "/myapp": (BuildContext context) => MyApp(),
          "/thirdapp": (BuildContext context) => ThirdApp()
        }
    )
  );
}

class Singleton {
  static GlobalKey<NavigatorState> mainNav = GlobalKey();
  static GlobalKey<NavigatorState> secondaryNav = GlobalKey();
}

class CustomPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 1000);

  CustomPageRoute({required builder}) : super(builder: builder);
}

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: TextButton(
          child: Text('Click me to go to my app'),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed("/thirdapp");
          },
        ),
        ),
      ),
    );
  }
}

class ThirdApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        child: Center(
          child: TextButton(
          child: Text('This is a third app'),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed("/myapp");
          },
        ),
        ),
      ),
    );
  }

}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (Utils.forLargeScreens(context)) {
       SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
    
    return Scaffold(
      appBar: Utils.forLargeScreens(context) ? null : 
        AppBar(
          iconTheme: IconThemeData(color: AppColors.MAIN_RED),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Icon(
            BofaFont.BOFA_LOGO,
            size: 80,
            color: AppColors.MAIN_RED
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () {},
                iconSize: 30,
                color: AppColors.MAIN_BACKGROUND,
                icon: Icon(Icons.notifications_outlined),
              )
            )
          ],
        ),
      drawer: Utils.forLargeScreens(context) ? null :
      Drawer(
        child: Container(
          color: AppColors.SECONDARY_RED
        ),
      ),
      backgroundColor: Utils.forLargeScreens(context) ? AppColors.MAIN_RED : Colors.white,
      body: Container(
          child: TabSwitcher(
              tabPages: [
                TabItem(
                  page: Page1(),
                  icon: BofaFont.TRANSACTIONS,
                  label: "Transactions",
                  route: "myapp/transactions"
                ),
                TabItem(
                  page: Page2(),
                  icon: BofaFont.PREFERENCES,
                  label: "Preferences",
                  route: "myapp/preferences"
                ),
                TabItem(
                  icon: BofaFont.OPTIONS,
                  page: TabPageSwitcher(),
                  label: "Additional Options",
                  route: "myapp/additionaloptions"
                ),
                TabItem(
                  icon: BofaFont.PROFILE,
                  page: TabPageSwitcher(),
                  label: "My Profile",
                  route: "myapp/switchingpage"
                )
              ],
            ),
      )
    );
  }
}

class TabItem {
  String? label;
  IconData? icon;
  Color tabSelected;
  Color tabNormal;
  Color tabDisabled;
  Widget? page;
  bool isSelected;
  String? route;

  TabItem({
    this.label,
    this.icon,
    this.isSelected = false,
    this.tabSelected = Colors.red,
    this.tabNormal = Colors.white,
    this.tabDisabled = Colors.grey,
    this.page,
    this.route
  });
}

class TabSwitcher extends StatefulWidget {

  bool slideIn = false;
  List<TabItem>? tabPages = [];
  Widget? selectedWidget = null;
  TabItem? currentTab = null;
  int selectedIndex = 0;

  TabSwitcher({ this.tabPages });

  @override
  _TabSwitcherState createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<TabSwitcher> {

  @override
  void initState() {
    super.initState();

    widget.selectedIndex = 0;
    widget.currentTab = widget.tabPages![0];
    widget.currentTab!.isSelected = true;
  }

  void selectedTabIndex(int index) {

    if (widget.selectedIndex != index) {
      widget.selectedIndex = index;
      setState(() {
        for(int i = 0; i < widget.tabPages!.length; i++) {
          widget.tabPages![i].isSelected = i == widget.selectedIndex;
        }
      });

      Singleton.secondaryNav.currentState!.pushReplacementNamed(widget.tabPages![widget.selectedIndex].route!);
    }
  }

  List<Widget> generateSideBar(bool asRow) {
    List<Widget> sideBarItems = [];

    if (!asRow) {
      sideBarItems.add(
        Container(
          margin: EdgeInsets.only(top: 10, right: 15, left: 15),
          decoration: BoxDecoration(
            color: AppColors.SECONDARY_RED,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              )
          ),
          padding: EdgeInsets.only(left: 22, right: 22, top: 20, bottom: 20),
          child: Icon(
            BofaFont.BOFA_LOGO,
            size: 130,
            color: Colors.white
          ),
        )
      );
    }

    for(int i = 0; i < widget.tabPages!.length; i++) {
      sideBarItems.add(
        GestureDetector(
          onTap: () {
            this.selectedTabIndex(i);
          },
          child: Container(
            margin: asRow ? EdgeInsets.only(bottom: 40) : EdgeInsets.only(left: 15, top: 15, bottom: 15),
            padding: asRow ? EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20) : EdgeInsets.only(top: 35, bottom: 35, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: asRow ? Radius.zero : Radius.circular(30),
                bottomLeft: Radius.circular(30),
                topRight: Radius.zero,
                bottomRight: asRow ? Radius.circular(30) : Radius.zero
              ),
              color: widget.tabPages![i].isSelected ? Colors.white : Colors.transparent,
            ),
            child: Column(
              children: [
                Icon(widget.tabPages![i].icon, 
                  color: widget.tabPages![i].isSelected ? AppColors.MAIN_RED : Colors.white,
                  size: asRow ? 40 : 60
                ),
                asRow ? SizedBox() : Container(
                  width: 150,
                  child: Text(widget.tabPages![i].label!,
                  textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.tabPages![i].isSelected ? AppColors.MAIN_RED : Colors.white,
                      fontSize: 20
                    )
                  ),
                )
              ],
            ),
          )
        )
      );
    }

    return sideBarItems;
  }

  @override
  Widget build(BuildContext context) {

    return Utils.forLargeScreens(context) ? Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.MAIN_RED,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: this.generateSideBar(false)
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40), bottomLeft: Radius.circular(40))
            ),
            child: Navigator(
                  key: Singleton.secondaryNav,
                  initialRoute: 'myapp/transactions',
                  onGenerateRoute: (RouteSettings settings) {
                    Widget? page;
                    //WidgetBuilder builder;

                    switch(settings.name) {
                      case 'myapp/transactions':
                        //builder = (BuildContext _) => widget.tabPages[0].page;
                        page = widget.tabPages![0].page;
                        break;
                      case 'myapp/preferences':
                        //builder = (BuildContext _) => widget.tabPages[1].page;
                        page = widget.tabPages![1].page;
                        break;
                      case 'myapp/additionaloptions':
                        //builder = (BuildContext _) => widget.tabPages[2].page;
                        page = widget.tabPages![2].page;
                        break;
                      case 'myapp/switchingpage':
                        //builder = (BuildContext _) => widget.tabPages[3].page;
                        page = widget.tabPages![3].page;
                        break;
                    }

                    return PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (context, animation, secondaryAnimation) => page!,
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
                            child: SlideTransition(
                              position: Tween(begin: Offset(0.1, 0.0), end: Offset.zero).animate(
                            CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
                              child: child,
                            )
                          );
                        },
                        transitionDuration: Duration(milliseconds: 250),
                        reverseTransitionDuration: Duration(milliseconds: 250),
                      );
                  },
                )
          ),
        )
      ],
    ) : Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Utils.forLargeScreens(context) ?
              BorderRadius.only(topLeft: Radius.circular(40), bottomLeft: Radius.circular(40))
              : BorderRadius.zero
            ),
            child: Navigator(
                  key: Singleton.secondaryNav,
                  initialRoute: 'myapp/transactions',
                  onGenerateRoute: (RouteSettings settings) {
                    Widget? page;
                    //WidgetBuilder builder;

                    switch(settings.name) {
                      case 'myapp/transactions':
                        //builder = (BuildContext _) => widget.tabPages[0].page;
                        page = widget.tabPages![0].page;
                        break;
                      case 'myapp/preferences':
                        //builder = (BuildContext _) => widget.tabPages[1].page;
                        page = widget.tabPages![1].page;
                        break;
                      case 'myapp/additionaloptions':
                        //builder = (BuildContext _) => widget.tabPages[2].page;
                        page = widget.tabPages![2].page;
                        break;
                      case 'myapp/switchingpage':
                        //builder = (BuildContext _) => widget.tabPages[3].page;
                        page = widget.tabPages![3].page;
                        break;
                    }

                    return PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (context, animation, secondaryAnimation) => page!,
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
                            child: SlideTransition(
                              position: Tween(begin: Offset(0.1, 0.0), end: Offset.zero).animate(
                            CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
                              child: child,
                            )
                          );
                        },
                        transitionDuration: Duration(milliseconds: 250),
                        reverseTransitionDuration: Duration(milliseconds: 250),
                      );
                  },
                )
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 40, right: 40),
          decoration: BoxDecoration(
            color: AppColors.MAIN_RED,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: this.generateSideBar(true)
          ),
        ),
      ],
    );
  }
}

class ButtonMetadata {
  String label;
  IconData iconData;
  bool isSelected = false;

  ButtonMetadata(this.label, this.iconData);
}

class Page0 extends StatefulWidget {

  @override
  _Page0State createState() => _Page0State();
}

class _Page0State extends State<Page0> {

  List<ButtonMetadata> items = [
    ButtonMetadata('Withdrawals', BofaFont.WITHDRAW),
    ButtonMetadata('Deposit', BofaFont.DEPOSIT),
    ButtonMetadata('Balance Inquiry', BofaFont.BALANCE),
    ButtonMetadata('Transfer', BofaFont.TRANSACTIONS),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(50),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                alignment: Alignment.centerLeft,
                child: Text('Select your transaction:',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.MAIN_BACKGROUND,
                    fontSize: 30
                  )
                ),
              ),
              Expanded(
                flex: 5,
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(4, (index) => 
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          items.forEach((element) {
                            element.isSelected = items[index] == element;
                          });
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(40),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: items[index].isSelected ? Color(0xFF41ACE8) : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: items[index].isSelected ? Color(0xFFB4E4FF) : Color(0xFFFFDEE3),
                              blurRadius: 20,
                              offset: Offset.zero
                            )
                          ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              items[index].iconData, 
                              color: items[index].isSelected ? Colors.white : AppColors.MAIN_RED, 
                              size: 100),
                            Text(items[index].label,
                              style: TextStyle(
                                color: items[index].isSelected ? Colors.white : AppColors.MAIN_RED, 
                                fontSize: 20)
                            )
                          ],
                        ),
                      ),
                    )
                  )  
                ),
              )
            ]
          )
        )
      )
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(50),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Please insert your card or tap your NFC-enabled phone',
                style: TextStyle(
                  color: AppColors.MAIN_BACKGROUND,
                  fontSize: 30
                )
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                      .pushReplacementNamed('myapp/preferences');
                    },
                    child: Container(
                    padding: EdgeInsets.all(30),
                    child: Icon(BofaFont.INSERT_CARD, size: 300, color: AppColors.MAIN_BACKGROUND),
                  ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                      .pushReplacementNamed('myapp/additionaloptions');
                    },
                    child: Container(
                    padding: EdgeInsets.all(30),
                    child: Icon(BofaFont.SCAN_PHONE, size: 300, color: AppColors.MAIN_BACKGROUND),
                  )
                  )
                ],
              )
            ],
          )
        ),
      )
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                alignment: Alignment.centerLeft,
                child: Text('Select your transaction:',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.MAIN_BACKGROUND,
                    fontSize: 30
                  )
                ),
              ),
              Container(
                color: Colors.grey[100],
                padding: EdgeInsets.all(60),
                child: Column(
                  children: [
                    Container(
                          padding: EdgeInsets.only(top: 15, bottom: 25, left: 30, right: 30),
                          width: 380,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.SECONDARY_RED,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 40,
                                offset: Offset.fromDirection(-300, 30)
                              )
                            ]
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(BofaFont.BOFA_LOGO, color: Colors.white, size: 60),
                                  Icon(BofaFont.VISA, color: Colors.white, size: 60)
                                ],
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(BofaFont.CHIP, color: Colors.yellow, size: 60),
                                    Text('3456 2234 7654 8978',
                                      style: TextStyle(color: Colors.white, fontSize: 20)
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Cardholder Name',
                                          style: TextStyle(color: Colors.white)
                                        ),
                                        Text('Roman Jaquez',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text('Exp. Date',
                                          style: TextStyle(color: Colors.white)
                                        ),
                                        Text('10/24',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)
                                        ),
                                      ],
                                    )
                                  ],
                                )
                            ],
                          )
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[300],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 40,
                                offset: Offset.fromDirection(-300, 30)
                              )
                            ]
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 50),
                                width: 380,
                                height: 40,
                                color: Colors.white
                              )
                            ],
                          ),
                          width: 380,
                          height: 250,
                        )
                  ],
                ),
              )
            ],
          ),
      )
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Page 3 333@@@@@@'),
      )
    );
  }
}

class TabPageSwitcher extends StatefulWidget {

  List<TabPage> pages = [
    TabPageWidget1(name: 'page1', goTo: 'page2', label: 'First one', icon: Icon(Icons.label), color: Colors.red),
    TabPageWidget1(name: 'page2', goTo: 'page1', label: 'Whatever', icon: Icon(Icons.label), color: Colors.red),
    TabPageWidget1(name: 'page3', goTo: 'page1',  label: 'third one', icon: Icon(Icons.label), color: Colors.red)
  ];

  TabPageSwitcher();

  @override
  _TabPageSwitcherState createState() => _TabPageSwitcherState();
}

class _TabPageSwitcherState extends State<TabPageSwitcher> {

  TabPage? currentPage = null;

  @override
  void initState() {
    super.initState();
    this.currentPage = widget.pages[0];
    this.wireUpOnPush();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void onPushPage(String? pageName) {
    this.wireUpOnPush();
    setState(() {
      this.currentPage = widget.pages.firstWhere((TabPage p) => p.name == pageName);
    });
  }

  void wireUpOnPush() {
    for(TabPage page in widget.pages) {
      page.onPushPage = this.onPushPage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: this.currentPage
      )
    );
  }
}

abstract class TabPage extends Widget {
  String? label;
  Icon? icon;
  Color? color;
  String? name;
  String? goTo;

  TabPage({this.name, this.label, this.icon, this.color, this.goTo});

  Function(String?)? onPushPage;
}

class TabPageWidget1 extends StatelessWidget implements TabPage {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(children: [
        Text(this.label!),
        TextButton(
          child: Text('click me'),
          onPressed: () {
            this.onPushPage!(this.goTo);
          },
        )
      ],))
    );
  }

  TabPageWidget1({ this.goTo, this.name, this.label, this.icon, this.color });

  @override
  Color? color;

  @override
  Icon? icon;

  @override
  String? label;

  @override
  Function(String?)? onPushPage;

  @override
  String? name;

  @override
  String? goTo;
}

class TabPageWidget2 extends StatelessWidget implements TabPage {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(children: [
        Text(this.label!),
        TextButton(
          child: Text('click me and see!'),
          onPressed: () {
            this.onPushPage!('page1');
          },
        )
      ],))
    );
  }

  TabPageWidget2({ this.name, this.label, this.icon, this.color });

  @override
  Color? color;

  @override
  Icon? icon;

  @override
  String? label;

  @override
  Function(String?)? onPushPage;

  @override
  String? name;

  @override
  String? goTo;

}

