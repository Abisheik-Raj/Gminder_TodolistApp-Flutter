import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("DataBox");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dataBox = Hive.box("DataBox");
  int categoryIndex = 0;
  Color businessColor  = Color.fromRGBO(183,10,215, 1.0);
  Color personalColor = Color.fromRGBO(56,76,129, 1.0);
  Color educationColor = Color.fromRGBO(56,76,129, 1);
  double businessThickness = 3.0;
  double personalThickness = 2.5;
  double educationThickness = 2.5;
  double businessProgress = 0.0;
  double personalProgress = 0.0;
  double educationProgress = 0.0;

  TextEditingController textEditingController = TextEditingController();
  Database db = Database();

  void calculateBusinessProgress(){
    int completedCount = 0;
    for(int i = 0;i<db.checks[0].length;i++){
      if(db.checks[0][i]==true){
        completedCount++;
      }
    }
    setState(() {
      // businessProgress = (db.checks[0].length/2);
      businessProgress = ((completedCount/db.checks[0].length) * 100)/100;
    });
  }

  void calculatePersonalProgress(){
    int completedCount = 0;
    for(int i = 0;i<db.checks[1].length;i++){
      if(db.checks[1][i]==true){
        completedCount++;
      }
    }
    setState(() {
      // businessProgress = (db.checks[0].length/2);
      personalProgress = ((completedCount/db.checks[1].length) * 100)/100;
    });
  }

  void calculateEducationProgress(){
    int completedCount = 0;
    for(int i = 0;i<db.checks[2].length;i++){
      if(db.checks[2][i]==true){
        completedCount++;
      }
    }
    setState(() {
      // businessProgress = (db.checks[0].length/2);
      educationProgress = ((completedCount/db.checks[2].length) * 100)/100;
    });
  }

  void calculateProgress(){
    calculateEducationProgress();
    calculatePersonalProgress();
    calculateBusinessProgress();
  }

  @override
  void initState(){

    if(dataBox.get("TASKS")==null){
        db.createInitialData();
    }
    else{
      db.loadData();}

    db.loadData();
    super.initState();
    calculateBusinessProgress();
    calculatePersonalProgress();
    calculateEducationProgress();
    calculateProgress();
  }

  void addTasks(){
    setState(() {
        db.tasks[categoryIndex].add(textEditingController.text);
        db.checks[categoryIndex].add(false);
        textEditingController.clear();
        db.saveData();
    });
  }

  void addNewTask(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFF2279FC),
                    borderRadius: BorderRadius.circular(50),
                  ) ,
                    child: IconButton(onPressed: () {
                      if(textEditingController.text.length > 0 && textEditingController.text.length < 25){
                        addTasks();
                        Navigator.pop(context);}
                    }, icon: Icon(Icons.arrow_upward,size: 25,),)),
              )],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            backgroundColor: Color(0xFF041955),
            content: Container(
              width: 300,
              height: 53,
              child: Column(
                children: <Widget>[
                 TextField(
                   controller: textEditingController,
                   decoration: InputDecoration(
                     hintText: "New Task",
                     hintStyle: TextStyle(color: Color.fromRGBO(144, 173, 241, 1.0),fontSize: 25),
                     border: InputBorder.none
                   ),
                   style: TextStyle(
                     fontSize: 25,
                     color: Color.fromRGBO(144, 173, 241, 1.0)
                   ),
                 ),
                ],
              ),
            ),
          );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addNewTask,
        child: Icon(Icons.add,color: Color(0xFF041955),size: 25,),
        backgroundColor: Color(0xFF2279FC),
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xFF041955),
          child: ListView(
            children: [
              DrawerHeader(
                  child: Center(child: Text("G M I N D E R",style: TextStyle(fontSize: 35,color: Color.fromRGBO(144, 173, 241, 1)),))
              ),
              ListTile(
                title:
                Container(
                  width: 100,
                  height: 50,
                child: Row(
                  children: [
                    Icon(Icons.person,size: 30,color: Color.fromRGBO(144, 173, 241, 1),),
                    SizedBox(width: 20,),
                    Text("Created by Abisheik Raj",style: TextStyle(color:Color.fromRGBO(144, 173, 241, 1),fontSize: 15),),
                  ],
                )),
              ),
              ListTile(
                title:
                Container(
                    width: 100,
                    height: 50,
                    child: Row(
                      children: [
                        Icon(Icons.design_services_outlined,size: 30,color: Color.fromRGBO(144, 173, 241, 1),),
                        SizedBox(width: 20,),
                        Text("Design inspired from Alex Arutuynov @dribble",style: TextStyle(color:Color.fromRGBO(144, 173, 241, 1),fontSize: 10 ),),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(52, 80, 161, 1.0),
        elevation: 0.0,
        leading: Icon(
          Icons.menu_sharp, color: Color.fromRGBO(144, 173, 241, 1),),
        // actions: [
        //   Icon(Icons.search_sharp, color: Color.fromRGBO(144, 173, 241, 1.0),),
        //   SizedBox(width: 20),
        //   Icon(Icons.notifications_none_sharp,
        //     color: Color.fromRGBO(144, 173, 241, 1.0),),
        //   SizedBox(width: 20)
        // ],
      ),
      body: Container(
        color: Color(0xFF3450A1),
        child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: Text("What's up, Gugapritha!", style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),)
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: Text("C A T E G O R I E S", style: TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(144, 173, 241, 1),
                    fontWeight: FontWeight.bold),)
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Container(
                width: 500,
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            categoryIndex = 0;
                            businessColor = Color.fromRGBO(183,10,215, 1.0);
                            personalColor = Color.fromRGBO(56,76,129, 1);
                            educationColor = Color.fromRGBO(56,76,129, 1);

                            businessThickness = 3.0;
                            personalThickness = 2.5;
                            educationThickness = 2.5;
                          });
                        },
                        child: Container(
                          width: 210,
                          decoration: BoxDecoration(
                            color: Color(0xFF041955),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 0),
                                  child: Text("${db.tasks[0].length} tasks", style: TextStyle(
                                      color: Color.fromRGBO(144, 173, 241, 1.0),
                                      fontSize: 17),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 10),
                                  child: Text("Business", style: TextStyle(
                                    color: Colors.white, fontSize: 25,),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6, top: 15,right: 6),
                                  child: LinearPercentIndicator(
                                      lineHeight: 2.5,
                                      percent: businessProgress,
                                      progressColor: Color.fromRGBO(183,10,215, 1.0),
                                      backgroundColor: Color.fromRGBO(56,76,129, 1),
                                  ),
                                )

                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 15, top: 15,right: 20),
                                //   child: Container(
                                //     height: businessThickness,
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(100),
                                //       color: businessColor,
                                //     ),
                                //     child: Divider(
                                //       color: Colors.transparent,
                                //       thickness: 3.0,
                                //       height: 2.0,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            categoryIndex = 1;
                            personalColor = Color.fromRGBO(36,126,238, 1);
                            businessColor = Color.fromRGBO(56,76,129, 1);
                            educationColor = Color.fromRGBO(56,76,129, 1);

                            personalThickness = 3.0;
                            businessThickness = 2.5;
                            educationThickness = 2.5;
                          });
                        },
                        child: Container(
                          width: 210,
                          decoration: BoxDecoration(
                              color: Color(0xFF041955),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 0),
                                  child: Text("${db.tasks[1].length} tasks", style: TextStyle(
                                      color: Color.fromRGBO(144, 173, 241, 1.0),
                                      fontSize: 17),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 10),
                                  child: Text("Personal", style: TextStyle(
                                    color: Colors.white, fontSize: 25,),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6, top: 15,right: 6),
                                  child: LinearPercentIndicator(
                                    lineHeight: 2.5,
                                    percent: personalProgress,
                                    progressColor: Color.fromRGBO(36,126,238, 1),
                                    backgroundColor: Color.fromRGBO(56,76,129, 1),
                                  ),
                                )
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 15, top: 15,right: 20),
                                //   child: Container(
                                //     height: personalThickness,
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(200),
                                //       color: personalColor,
                                //     ),
                                //     child: Divider(
                                //       color: Colors.transparent,
                                //       thickness: 3.0,
                                //       height: 3.0,
                                //     ),
                                //   ),
                                // ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            categoryIndex = 2;
                            educationColor = Color.fromRGBO(183,10,215, 1);
                            businessColor = Color.fromRGBO(56,76,129, 1);
                            personalColor = Color.fromRGBO(56,76,129, 1);

                            educationThickness = 3.0;
                            personalThickness = 2.5;
                            businessThickness = 2.5;
                          });
                        },
                        child: Container(
                          width: 210,
                          decoration: BoxDecoration(
                              color: Color(0xFF041955),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 0),
                                  child: Text("${db.tasks[2].length} tasks", style: TextStyle(
                                      color: Color.fromRGBO(144, 173, 241, 1.0),
                                      fontSize: 17),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 10),
                                  child: Text("Education", style: TextStyle(
                                    color: Colors.white, fontSize: 25,),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6, top: 15,right: 6),
                                  child: LinearPercentIndicator(
                                    lineHeight: 2.5,
                                    percent: educationProgress,
                                    progressColor: Color.fromRGBO(183,10,215, 1),
                                    backgroundColor: Color.fromRGBO(56,76,129, 1),
                                  ),
                                )
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 15, top: 15,right: 20),
                                //   child: Container(
                                //     height: educationThickness,
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(100),
                                //       color: educationColor,
                                //     ),
                                //     child: Divider(
                                //       color: Colors.transparent,
                                //       thickness: 3.0,
                                //       height: 2.0,
                                //     ),
                                //   ),
                                // ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("T A S K S", style: TextStyle(fontSize: 12,
                  color: Color.fromRGBO(144, 173, 241, 1),
                  fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                width: 100,
                height: 400,
                child: ListView.builder(
                  itemCount: db.tasks[categoryIndex].length,
                  itemBuilder: (BuildContext context,int index){
                    return TaskWidget(taskContent: db.tasks[categoryIndex][index], done: db.checks[categoryIndex][index],onCheckBoxChanged: () {db.checks[categoryIndex][index] = !db.checks[categoryIndex][index];db.saveData();},deleteFromList: () {
                      setState(() {
                        db.tasks[categoryIndex].removeAt(index);
                        db.checks[categoryIndex].removeAt(index);
                        db.saveData();
                      });
                      },
                      checkCircleColor: (categoryIndex == 0) || (categoryIndex %2==0) ? Color.fromRGBO(183,10,215, 1) : Color.fromRGBO(36,126,238, 1),
                      calculateProgress: calculateProgress,
                    );
                  },
                )
              ),
            ),
          ],
        ),

      ),
    );
  }
}

class TaskWidget extends StatefulWidget {
  String taskContent;
  bool done;
  Function() onCheckBoxChanged;
  Function() deleteFromList;
  Function() calculateProgress;
  Color checkCircleColor;

   TaskWidget({
     super.key,
     required this.taskContent,
     required this.done,
     required this.onCheckBoxChanged,
     required this.deleteFromList,
     required this.checkCircleColor,
     required this.calculateProgress,
  });

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  void changeCheck(){
    setState(() {
      this.widget.done = !this.widget.done;
      this.widget.onCheckBoxChanged();
      this.widget.calculateProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
        child: Dismissible(
          key: Key(this.widget.taskContent),
          background: Container(
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.red,
            ),
            child: Icon(Icons.delete),
          ),
          onDismissed: (direction) {
            this.widget.deleteFromList();
          },
          child: Container(
            height: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF041955)
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 10),
                  child: this.widget.done ? IconButton(icon: Icon(Icons.check_circle, size: 35,
                    color: this.widget.checkCircleColor),onPressed: changeCheck, ) : IconButton(icon: Icon(Icons.circle_outlined,size: 35,color: this.widget.checkCircleColor),onPressed: changeCheck),
                ),
                Text(this.widget.taskContent, style: TextStyle(
                    color: Colors.white, fontSize: 19,decoration: this.widget.done ? TextDecoration.lineThrough : TextDecoration.none,decorationColor: Colors.white,decorationThickness: 2.0),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

class Database {
  final dataBox = Hive.box("DataBox");
  List<List<String>> tasks = [[], [], []];
  List<List<bool>> checks = [[], [], []];

  void createInitialData() {
    tasks = [["Business task  💼"], ["Personal task  👪"], ["Education task  🏫"]];
    checks = [[false], [false], [false]];
  }

  void loadData() {
    var loadedTasks = dataBox.get("TASKS");
    var loadedChecks = dataBox.get("CHECKS");

    if (loadedTasks != null && loadedChecks != null) {
      // Assuming loadedTasks and loadedChecks are of type List<dynamic>
      tasks = List<List<String>>.from(loadedTasks);
      checks = List<List<bool>>.from(loadedChecks);
    }
  }

  void saveData() {
    dataBox.put("TASKS", tasks);
    dataBox.put("CHECKS", checks);
  }
}
