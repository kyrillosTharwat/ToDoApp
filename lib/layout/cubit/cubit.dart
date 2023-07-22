
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/cubit/states.dart';

import '../../modules/archived_scr.dart';
import '../../modules/done_scr.dart';
import '../../modules/new_tasks_scr.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super (AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Map> tasks = [];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  List<Text>titles =
  [
    Text('Tasks'),
    Text('Done Tasks'),
    Text('Archived'),
  ];
  List<Widget>Screens =
  [
    new_tasks(),
    done_scr(),
    archived_scr(),
  ];
  late Database database;
  void changeIndex (int index)
  {
    currentIndex=index;
    emit(AppChangeNavBarIndex());
  }
  void createDatabase()
  {
     openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database,version)
        {
          print('database created');
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then((value)
          {
            print('table created');
          }).catchError((error){
            print('error on creating table $error');
          });
        },
        onOpen: (database)
        {
          getDataFromDatabase(database);
          print('database opened');
        }
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
     });
  }
   insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async
  {
      await database.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")'
      )
          .then((value)  {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error){
        print('error on inserting new record $error');
      });
      return null;
    });
  }
  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      tasks=value;
      tasks.forEach((element)
      {
        if(element['status'] == 'new') {
          newTasks.add(element);
        }
        else if (element['status'] == 'done') {
          doneTasks.add(element);
        }
        else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }
  void updateData({
    required String status,
    required int id,
  }) async{
     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id],
    ).then((value)
     {
       getDataFromDatabase(database);
       emit(AppUpdateDatabaseState());
     });
  }
  void deleteData({
    required int id,
  }) async{
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool showBottomSheet=false;
  IconData fabIcon=Icons.edit;
  void changeBottomSheet({
  required bool isShow,
  required IconData icon,
  })
  {
    showBottomSheet = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
/*
tasks.forEach((element)
{
  if(element['done']=='true'){
    donetasks.add(element);
}
}*/
