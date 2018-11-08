// File created by
// Lung Razvan <long1eu>
// on 22/10/2018

import 'dart:async';

import 'package:firebase_storage/src/internal/task_events.dart';
import 'package:firebase_storage/src/internal/task_proxy.dart';
import 'package:firebase_storage/src/task.dart';

class TaskImpl<TState extends StorageTaskState> extends Task<TState> {
  final Sender _send;
  final Stream<dynamic> _received;
  final Completer<dynamic> _completer;

  int _id = 0;

  TaskImpl(this._send, this._received, this._completer);

  @override
  Future<void> get future => _completer.future;

  @override
  Future<bool> cancel() => _callMethod('cancel');

  @override
  Future<bool> pause() => _callMethod('pause');

  @override
  Future<bool> resume() => _callMethod('resume');

  @override
  Future<bool> get isCanceled => _callMethod('isCanceled');

  @override
  Future<bool> get isInProgress => _callMethod('isInProgress');

  @override
  Future<bool> get isPaused => _callMethod('isPaused');

  Future<bool> _callMethod(String method) async {
    final int id = ++_id;
    _send(<dynamic>[id, method]);

    final bool result = (await _received
        .where((dynamic it) => it[0] == id && it[1] == method)
        .first)[2];
    return result;
  }

  @override
  Stream<TaskEvent<TState>> get events => _received
      .where((dynamic data) => data is TaskPayload)
      .cast<TaskPayload>()
      .map(TaskEvent.deserialized);
}