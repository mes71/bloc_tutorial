import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

const names = ['foo', 'bar', 'baz'];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(Random().nextInt(length));
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() => emit(names.getRandomElement());
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final NamesCubit cubit;

  @override
  void initState() {
    super.initState();

    cubit = NamesCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cube 01'),
        centerTitle: true,
      ),
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        builder: (context, snapshot) {
          final button = TextButton(
              onPressed: () => cubit.pickRandomName(),
              child: const Text(
                'pick new name',
                style: TextStyle(fontSize: 28),
              ));

          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return button;

            case ConnectionState.active:
              return Center(
                child: Column(
                  children: [Text(snapshot.data ?? ''), button],
                ),
              );
            case ConnectionState.done:
              return Container(
                width: 50,
                height: 50,
                color: Colors.amber,
              );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    cubit.close();
  }
}
