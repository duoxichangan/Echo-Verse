import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// 从相册选一张图并持久化到 App 文档目录，返回保存后的路径（取消返回 null）。
///
/// image_picker 给的是临时路径，需复制到永久目录。头像、表情包共用。
Future<String?> pickAndSaveImage({String subDir = 'images', String prefix = 'img'}) async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (picked == null) return null;

  final dir = await getApplicationDocumentsDirectory();
  final destDir = Directory(p.join(dir.path, subDir));
  if (!destDir.existsSync()) destDir.createSync(recursive: true);

  final ext = p.extension(picked.path);
  final dest =
      p.join(destDir.path, '${prefix}_${DateTime.now().millisecondsSinceEpoch}$ext');
  await File(picked.path).copy(dest);
  return dest;
}
