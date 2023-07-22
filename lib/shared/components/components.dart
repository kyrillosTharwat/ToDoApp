
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../../layout/cubit/cubit.dart';

Widget defaultButton(
 {
     double width = double.infinity,
     Color  color = Colors.blue,
     required Function function,
     required String text,
     bool isUpper = true,
 }
) =>
    Container(
        width: double.infinity,
        color: Colors.blue,
        child: MaterialButton(
          onPressed: function(),
          child: Text(
                   isUpper ? text.toUpperCase() : text,
               style: TextStyle(
                    color: Colors.white,
                      ),
                  ),
        ),
     );
class DefaultFormField extends StatelessWidget {
  DefaultFormField({
    required this.onTap,
    Key? key,
    required this.controller,
    required this.label,
    required this.type,
    this.suffix,
    this.onPressedSuffix,
    this.enableReadOnly = false,
    this.errorMessage,
    required this.isUpSecure,
    required this.isSuffixClicked,
  }) : super(key: key);
  final TextEditingController controller;
  final TextInputType type;
  final String label;
  final String? errorMessage;
  IconData? suffix;
  Function? onPressedSuffix;
  bool? enableReadOnly;
  bool isSuffixClicked;
  bool isUpSecure;
  late Function onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 15),
      onTap: onTap(),
      obscureText: isUpSecure,
      controller: controller,
      readOnly: enableReadOnly!,
      keyboardType: type,
      validator: (value) {
        if (value!.isEmpty) {
          return '${errorMessage ?? 'This field'} can not be empty';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: isSuffixClicked
            ? IconButton(
          onPressed: () {
            onPressedSuffix!();
          },
          icon: Icon(suffix),
        )
            : Icon(suffix),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
 Widget buildTaskItem(Map model, context) => Dismissible(
   key: Key(model['id'].toString()),
   onDismissed: (direction)
   {
      AppCubit.get(context).deleteData(id: model['id']);
   },
   child: Padding(
     padding: const EdgeInsets.all(20.0),
     child: Row(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         CircleAvatar(
           radius: 35.0,
           child: Text(
             '${model['time']}',
           ),
         ),
         SizedBox(
           width:10,
         ),
         Expanded(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
             children: [
               Text(
                 '${model['title']}',
                 style: TextStyle(
                   color: Colors.black,
                   fontWeight: FontWeight.bold,
                   fontSize: 20,
                 ),
               ),
               SizedBox(height: 5,),
               Text(
                 '${model['date']}',
                 style: TextStyle(
                   color: Colors.grey,
                   fontWeight: FontWeight.bold,
                 ),
               ),
             ],
           ),
         ),
         SizedBox(
           width:10,
         ),
         IconButton(
             onPressed: () {
              AppCubit.get(context).updateData(status: 'done', id: model['id']);
             },
             icon: Icon(
                 Icons.check,
               color: Colors.green,
             )
         ),
         IconButton(
             onPressed: () {
               AppCubit.get(context).updateData(
                   status: 'archived',
                   id: model['id'],
               );
             },
             icon: Icon(
               Icons.archive,
               color: Colors.black45,
             )
         ),
       ],
     ),
   ),
 );
 Widget buildConditionalBuilder({
  required List<Map>tasks,
 }
 ) => ConditionalBuilder(
   condition: tasks.length > 0,
   fallback: (context) => Center(
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.center,
       mainAxisAlignment: MainAxisAlignment.center,
       children:const [
         Icon(
           Icons.menu,
           color: Colors.grey,
           size: 50,
         ),
         SizedBox(height: 5,),
         Text(
           'There are no tasks yet, Please add a new task',
           style: TextStyle(
             color: Colors.grey,
             fontSize: 15,
             fontWeight: FontWeight.bold,
           ),
         )
       ],
     ),
   ),
   builder:(context)=> ListView.separated(
     itemBuilder: (context, index) => buildTaskItem(tasks[index], context,),
     separatorBuilder: (context, index) => Container(
       width: double.infinity,
       color: Colors.grey[300],
       height: 1.0,
     ),
     itemCount:tasks.length,
   ),
 );
void navigateTo(context,Widget)
  {
     Navigator.push(context, MaterialPageRoute(
       builder: (context) =>  Widget));
  }