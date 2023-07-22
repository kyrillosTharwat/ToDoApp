
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../layout/cubit/cubit.dart';
import '../layout/cubit/states.dart';

class new_tasks extends StatelessWidget {
  const new_tasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state)=>buildConditionalBuilder(tasks: AppCubit.get(context).newTasks)
    );
  }
}
