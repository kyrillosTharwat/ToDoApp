
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../shared/components/components.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class HomeScreen extends StatelessWidget
{
  var scaffoldKey=GlobalKey<ScaffoldState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey=GlobalKey<FormState>();

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => (AppCubit()..createDatabase()),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state)
        {
          if (state is AppInsertDatabaseState)
            Navigator.pop(context);
        },
        builder: (context, state){
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              centerTitle:true,
              title: AppCubit.get(context).titles [AppCubit.get(context).currentIndex],
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => AppCubit.get(context).Screens[AppCubit.get(context).currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed:()
              {
                if(AppCubit.get(context).showBottomSheet)
                {
                  AppCubit.get(context).insertToDatabase
                    (
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    );
                  AppCubit.get(context).changeBottomSheet(isShow: false, icon: Icons.edit);
                  AppCubit.get(context).fabIcon = Icons.edit;
                }
                else
                {
                  scaffoldKey.currentState!.showBottomSheet((context) =>
                      Container(
                        color: Colors.grey[100],
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DefaultFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                onTap: (){},
                                label: 'Title',
                                isUpSecure: false,
                                isSuffixClicked: false,
                                suffix: Icons.title,
                              ),
                              SizedBox(height: 15,),
                              DefaultFormField(
                                  controller: timeController,
                                  type: TextInputType.text,
                                  onTap: (){},
                                  label: 'time',
                                  isSuffixClicked:true,
                                  isUpSecure: false,
                                  suffix: Icons.watch_later_outlined,
                                  onPressedSuffix: ()
                                  {
                                    showTimePicker(context: context, initialTime: TimeOfDay.now()
                                    ).then((value)
                                    {
                                      timeController.text=(value!.format(context).toString());
                                    }
                                    );
                                  }
                              ),
                              SizedBox(height: 15,),
                              DefaultFormField(
                                  isSuffixClicked:true,
                                  isUpSecure: false,
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  onTap: (){},
                                  label: 'date',
                                  suffix: Icons.calendar_month_outlined,
                                  onPressedSuffix: ()
                                  {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate:DateTime.now(),
                                      lastDate: DateTime.parse('2099-03-03'),
                                    ).then((value) {
                                      dateController.text=DateFormat.yMMMd().format(value!);
                                    });
                                  }
                              )
                            ],
                          ),
                        ),
                      ),
                  ).closed.then((value) {
                   AppCubit.get(context).changeBottomSheet(
                       isShow: false, icon: Icons.edit,
                   );
                  });
                 AppCubit.get(context).changeBottomSheet(
                   isShow: true, icon: Icons.add,
                 );
                }

              },
              child: Icon(
                AppCubit.get(context).fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex:AppCubit.get(context).currentIndex,
              onTap: (index) {
             AppCubit.get(context).changeIndex(index);
              },
              items:
              const [
                BottomNavigationBarItem(
                  label: 'Tasks',
                  icon:Icon(
                    Icons.menu,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Done',
                  icon:Icon(
                    Icons.check_circle_outline,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Archived',
                  icon:Icon(
                    Icons.archive_outlined,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
