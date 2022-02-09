import 'package:flutter/material.dart';
import 'package:mytodo/screens/taskpage.dart';

import '../database_helper.dart';
import '../widgets.dart';


class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  var dateTime=new DateTime.now();
  dynamic l=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reset();
  }

  @override
  Widget build(BuildContext context) {
    int hour=dateTime.hour;
    String greet="";
    if(hour>=0 && hour<=3)
      greet="Night Owl";
    else if(hour>3&& hour<12)
      greet="Good Morning";
    else if(hour>=12&& hour<=15)
      greet="Good Afternoon";
    else if(hour>15&& hour<23)
      greet="Good Evening";

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          color: Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 32.0,
                      bottom: 32.0,
                    ),
                    child: Text("Hey, $greet",style: TextStyle(
                      fontSize: 30,
                      fontStyle: FontStyle.italic
                    ),),
                  ),


                  
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTasks(),
                      builder: (context,AsyncSnapshot snapshot) {
                        l=snapshot.data.length;
                        print(l);

                        return (l>0)?ScrollConfiguration(
                          behavior: NoGlowBehaviour(),
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Taskpage(
                                        task: snapshot.data[index],
                                      ),
                                    ),
                                  ).then(
                                    (value) {
                                      setState(() {});
                                    },
                                  );
                                },
                                child: TaskCardWidget(
                                  title: snapshot.data[index].title,
                                  desc: snapshot.data[index].description,
                                ),
                              );
                            },

                          ),
                        ):Center(
                          child: Text("Nothing to show you."),
                        );
                      },
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Taskpage(
                                task: null,
                              )),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xF7040110), Color(0xBC06281C)],
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0)),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Image(
                      image: AssetImage(
                        "assets/images/add_icon.png",
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void reset() async{
    int hour=dateTime.hour;
    int min=dateTime.minute;
    int sec=dateTime.second;
    if(hour==0&& min==0 && sec==0) {
      await _dbHelper.deleteAll();
    }
  }
}
