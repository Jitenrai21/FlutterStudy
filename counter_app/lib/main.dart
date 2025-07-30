import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'provider/counter_provider.dart';
import 'bloc/counter_bloc.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterProvider()),
        BlocProvider(create: (_) => CounterBloc()),
      ],
      child: MaterialApp(
        title: 'JKR State Management Task',
        theme: ThemeData.dark(),
        home: HomeScreen(),
      ),
    );
  }
}
