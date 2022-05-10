import 'dart:isolate';

import 'package:async/async.dart';

class ServiceUtils {
  static Map<String, Service> _serviceMap = new Map<String, Service>();

  static Future<Service> getService(String name, WorkLoad onExecute,
      [Map? initArgs]) async {
    if (!_serviceMap.containsKey(name)) {
      var service = new Service();
      await service._start(onExecute, initArgs);
      _serviceMap[name] = service;
    }
    return _serviceMap[name]!;
  }

  static bool hasService(String name) {
    return _serviceMap.containsKey(name);
  }
}

typedef WorkLoad = Future<void> Function(
    SendPort sendPort, ReceivePort receivePort, Map? initArgs);

class FirstRunArgument {
  late SendPort port;
  WorkLoad onExecute;
  Map? initArgs;

  FirstRunArgument(
      {required this.port, required this.onExecute, required this.initArgs});
}

class Service {
  late StreamQueue _events;
  late SendPort _isolatePort;

  Future<void> _start(WorkLoad onExecute, Map? initArgs) async {
    var p = ReceivePort();
    await Isolate.spawn(
        Service._run,
        FirstRunArgument(
            port: p.sendPort, onExecute: onExecute, initArgs: initArgs));
    _events = StreamQueue<dynamic>(p);
    _isolatePort = await _events.next;
  }

  Future<dynamic> execute(dynamic msg) async {
    _isolatePort.send(msg);
    return await _events.next;
  }

  static void _run(FirstRunArgument arguments) async {
    var p = ReceivePort();
    arguments.port.send(p.sendPort);
    await arguments.onExecute(arguments.port, p, arguments.initArgs);
    Isolate.exit();
  }
}
