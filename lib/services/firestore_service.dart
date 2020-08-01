import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';



class FirestoreService{
  //private constructor, so that objects outside firestore service cant tap into it
  //In summary it is to ensure that only one object with firestoreService can be created.
  FirestoreService._();
  static final instance=FirestoreService._();


  Future<void> setData({@required String path, @required Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    
    await reference.setData(data);
  }
  
  Future<void> deleteData({@required String path})async{
    final reference=Firestore.instance.document(path);
    await reference.delete();
  }

 

  //generic blueprint for reading data
  Stream<List<T>> collectionStream<T>({
    @required String path,@required T builder(Map<String, dynamic> data,String documentId),
  }){
    
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();

    return snapshots.map((event) =>
        event.documents.map((element) => builder(element.data,element.documentID)).toList());
  }
}