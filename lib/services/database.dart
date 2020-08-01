import 'package:flutter/material.dart';
import 'package:ui_practice/models/job.dart';
import 'package:ui_practice/services/firestore_service.dart';

import 'api_path.dart';

abstract class DataBase {
  Future<void> setJob(Job job); 

  Stream<List<Job>> jobsStream();
  Future<void> deleteJob(Job job);
}
String documentIdFromCurrentDate()=>DateTime.now().toIso8601String();


class FirestoreDatabase implements DataBase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;
  final _service = FirestoreService.instance;
  @override
  Future<void> setJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );
  @override
  Future<void> deleteJob(Job job)async=>await _service.deleteData(path: APIPath.job(uid, job.id));
  
  Stream<List<Job>> jobsStream() => _service.collectionStream(
      path: APIPath.jobs(uid), builder: (data,documentId) => Job.fromMap(data,documentId));
}
