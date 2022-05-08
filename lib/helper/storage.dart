import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<String> uploadProfile(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      await storage.ref('imageProfile/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
    String downloadURL = await storage.ref('imageProfile/$fileName').getDownloadURL();
    return downloadURL;
  }

  Future<String> uploadForum(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      await storage.ref('imageForum/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
    String downloadURL = await storage.ref('imageForum/$fileName').getDownloadURL();
    return downloadURL;
  }

  Future<String> uploadEvent(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      await storage.ref('imageEvent/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
    String downloadURL = await storage.ref('imageEvent/$fileName').getDownloadURL();
    return downloadURL;
  }

  Future<String> uploadCommu(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      await storage.ref('imageCommunity/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
    String downloadURL = await storage.ref('imageCommunity/$fileName').getDownloadURL();
    return downloadURL;
  }

}