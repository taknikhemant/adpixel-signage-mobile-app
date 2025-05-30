import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_provider/path_provider.dart';

import '../screen/home/models/device_templete_data_model.dart';

class FileDownloader {
  // Your existing Dio code...
  // Add below after downloading and updating

// b41f8d
// 44cb0d retail
// 5b976e  school

  Future<void> downloadFile(Carousal item, {String? category}) async {
    try {
      final dio = Dio();

      final dir = await getApplicationDocumentsDirectory();

      final filename = '${item.sequence}_${item.file!.split('/').last}';
      final filePath = '${dir.path}/$filename';

      await dio.download(
        item.file!,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            log("Downloading: ${(received / total * 100).toStringAsFixed(0)}%",
                name: "downloadFileWithDio");
          }
        },
      );

      // Save with category
      List<Carousal> saved = await loadFromSharedPrefs();
      saved.add(Carousal(
        sequence: item.sequence,
        file: item.file,
        fileType: item.fileType,
        localFile: filePath,
        category: category,
      ));
      await saveToSharedPrefs(saved);
    } catch (e) {
      log("Dio Download error: $e", name: "downloadFileWithDio");
    }
  }

  Future<void> removeFile(Carousal item) async {
    // Remove file from disk if it exists
    final file = File(item.localFile!); // Ensure localPath is correctly set
    if (await file.exists()) {
      await file.delete();
    }

    // Remove entry from saved list in SharedPreferences
    List<Carousal> saved = await loadFromSharedPrefs();
    saved.removeWhere((savedItem) => savedItem.file == item.file);

    await saveToSharedPrefs(saved);
  }

  Future<void> saveToSharedPrefs(List<Carousal> files) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedList =
        files.map((media) => jsonEncode(media.toJson())).toList();

    await prefs.setStringList('downloaded_media_files', encodedList);
  }

  Future<List<Carousal>> loadFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('downloaded_media_files');
    if (encodedList == null) return [];

    return encodedList.map((e) => Carousal.fromJson(jsonDecode(e))).toList();
  }

  Future<bool> clearAllSharePrefData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  Future<void> clearAllDownloadedFiles() async {
    try {
      // Delete saved downloaded files
      List<Carousal> saved = await loadFromSharedPrefs();

      for (final item in saved) {
        final file = File(item.localFile ?? '');
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Clear shared preferences
      await clearAllSharePrefData();

      // Delete all files in the temporary directory
      final tempDir = await getTemporaryDirectory();
      if (await tempDir.exists()) {
        tempDir.listSync().forEach((file) {
          try {
            if (file is File) {
              file.deleteSync();
            } else if (file is Directory) {
              file.deleteSync(recursive: true);
            }
          } catch (e) {
            log("Failed to delete temp file: $e",
                name: "clearAllDownloadedFiles");
          }
        });
      }

      log("All downloaded files, temporary files, and shared preferences cleared.",
          name: "clearAllDownloadedFiles");
    } catch (e) {
      log("Error while clearing downloaded files: $e",
          name: "clearAllDownloadedFiles");
    }
  }
}
