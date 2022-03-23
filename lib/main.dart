import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: Scaffold(body: HomePage()),
      ),
    ),
  );
}

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Workaround: watch the .future provider directly
    // ref.watch(dataProvider.future);

    final value = ref.watch(dataProvider).value;

    return RefreshIndicator(
      onRefresh: () => ref.refresh(dataProvider.future),
      child: ListView.builder(
        itemCount: value?.length ?? 1,
        itemBuilder: _valueItemBuilder(value),
      ),
    );
  }
}

IndexedWidgetBuilder _valueItemBuilder(List<String>? value) {
  return (context, index) => value != null
      ? ListTile(
          title: Text(value[index]),
        )
      : Container(
          alignment: Alignment.center,
          width: 48.0,
          height: 48.0,
          margin: const EdgeInsets.all(120.0),
          child: const CircularProgressIndicator(),
        );
}

final dataProvider = FutureProvider.autoDispose((ref) async {
  await Future.delayed(const Duration(seconds: 3));

  final random = Random();
  return List.generate(20, (index) => random.nextInt(100).toString());
});
