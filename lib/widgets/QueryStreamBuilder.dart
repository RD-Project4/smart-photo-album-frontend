import 'dart:async';

import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

class QueryStream<T> {
  final QueryBuilder<T> queryBuilder;
  late final Query<T> query;
  late final Stream<Query<T>> stream;

  QueryStream(Store store, this.queryBuilder) {
    query = queryBuilder.build();
    late StreamSubscription<void> subscription;
    late StreamController<Query<T>> controller;
    final subscribe = () {
      subscription = store.entityChanges.listen((List<Type> entityTypes) {
        if (entityTypes.contains(T)) {
          controller.add(query);
        }
      });
    };
    controller = StreamController<Query<T>>(
        onListen: subscribe,
        onResume: subscribe,
        onPause: () => subscription.pause(),
        onCancel: () => subscription.cancel());
    this.stream = controller.stream.asBroadcastStream();
  }
}

class QueryStreamBuilder<T> extends StatelessWidget {
  final QueryStream<T> queryStream;
  final Widget Function(BuildContext, List<T>) builder;
  final Widget? loadingWidget;

  const QueryStreamBuilder(
      {required this.queryStream, required this.builder, this.loadingWidget});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: queryStream.query,
        stream: queryStream.stream,
        builder: (context, snapshot) => snapshot.hasData
            ? builder(context, (snapshot.data as Query<T>).find())
            : (loadingWidget ?? Container()));
  }
}
