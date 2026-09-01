import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '/core/data/timetable_data.dart';
import '/core/theme/app_colors.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  static const List<_SubjectSeed> _subjects = [
    _SubjectSeed(
      code: 'BCS-501',
      title: 'Database Management System',
      subtitle: 'DBMS',
    ),
    _SubjectSeed(code: 'BCS-502', title: 'Web Technology', subtitle: 'WT'),
    _SubjectSeed(
      code: 'BCS-503',
      title: 'Design & Analysis of Algorithm',
      subtitle: 'DAA',
    ),
    _SubjectSeed(code: 'BCS-052', title: 'Data Analytics', subtitle: 'DA'),
    _SubjectSeed(code: 'BCS-055', title: 'Machine Learning', subtitle: 'ML'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Study Store',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.file_present_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Upload and keep material for each subject',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.darkSecondaryText
                      : AppColors.lightSecondaryText,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _subjects.length,
                  itemBuilder: (context, index) {
                    final subject = _subjects[index];
                    return _SubjectCard(subject: subject, isDark: isDark);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final _SubjectSeed subject;
  final bool isDark;

  const _SubjectCard({required this.subject, required this.isDark, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push('/store/${subject.code}'),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                subject.subtitle,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.code,
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 0.3,
                      color: isDark
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subject.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectSeed {
  final String code;
  final String title;
  final String subtitle;

  const _SubjectSeed({
    required this.code,
    required this.title,
    required this.subtitle,
  });
}

class SubjectStoreScreen extends StatefulWidget {
  final String subjectCode;

  const SubjectStoreScreen({super.key, required this.subjectCode});

  @override
  State<SubjectStoreScreen> createState() => _SubjectStoreScreenState();
}

class _SubjectStoreScreenState extends State<SubjectStoreScreen> {
  List<_StoredFile> _files = [];

  TSubject? get _subject {
    for (final subject in AppTimetable.allSubjects) {
      if (subject.code == widget.subjectCode) {
        return subject;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _loadStoreFiles();
  }

  Future<void> _loadStoreFiles() async {
    final directory = await _subjectDirectory;
    if (!await directory.exists()) {
      if (!mounted) return;
      setState(() => _files = const []);
      return;
    }

    final files = await directory.list().toList();
    final stored = <_StoredFile>[];
    for (final item in files) {
      if (item is File) {
        stored.add(
          _StoredFile(
            name: item.uri.pathSegments.last,
            path: item.path,
            size: await _readFileSize(item),
            modifiedAt: await item.lastModified(),
          ),
        );
      }
    }

    stored.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));

    if (!mounted) return;
    setState(() => _files = stored);
  }

  Future<int> _readFileSize(File file) async {
    try {
      final bytes = await file.length();
      return bytes;
    } catch (_) {
      return 0;
    }
  }

  Future<Directory> get _subjectDirectory async {
    final root = await getApplicationDocumentsDirectory();
    return Directory('${root.path}/study_store/${widget.subjectCode}');
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        final photoStatus = await Permission.photos.request();
        final videoStatus = await Permission.videos.request();

        final granted =
            photoStatus.isGranted ||
            photoStatus.isLimited ||
            videoStatus.isGranted ||
            videoStatus.isLimited;

        if (granted) return true;
        if (photoStatus.isPermanentlyDenied ||
            videoStatus.isPermanentlyDenied) {
          await openAppSettings();
        }
        return false;
      }

      final storageStatus = await Permission.storage.request();
      if (storageStatus.isGranted || storageStatus.isLimited) return true;
      if (storageStatus.isPermanentlyDenied) {
        await openAppSettings();
      }
      return false;
    }

    if (Platform.isIOS) {
      final photosStatus = await Permission.photos.request();
      if (photosStatus.isGranted || photosStatus.isLimited) return true;
      if (photosStatus.isPermanentlyDenied) {
        await openAppSettings();
      }
      return false;
    }

    return true;
  }

  Future<void> _uploadFile() async {
    final granted = await _requestStoragePermission();
    if (!granted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Storage permission is required to upload study files.',
          ),
        ),
      );
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'ppt',
        'pptx',
        'txt',
        'png',
        'jpg',
        'jpeg',
        'zip',
      ],
    );

    if (result == null || result.files.single.path == null) {
      return;
    }

    final sourceFile = File(result.files.single.path!);
    final targetDir = await _subjectDirectory;
    await targetDir.create(recursive: true);

    final fileName = _buildUniqueFileName(targetDir, result.files.single.name);
    final targetFile = File('${targetDir.path}/$fileName');
    await targetFile.writeAsBytes(await sourceFile.readAsBytes());

    await _loadStoreFiles();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Uploaded to ${_subject?.code ?? widget.subjectCode}'),
      ),
    );
  }

  String _buildUniqueFileName(Directory directory, String originalName) {
    final baseName = originalName.split('/').last;
    final separatorIndex = baseName.lastIndexOf('.');
    final name = separatorIndex == -1
        ? baseName
        : baseName.substring(0, separatorIndex);
    final extension = separatorIndex == -1
        ? ''
        : baseName.substring(separatorIndex);

    var candidate = baseName;
    var index = 1;
    while (File('${directory.path}/$candidate').existsSync()) {
      candidate = '$name ($index)$extension';
      index++;
    }
    return candidate;
  }

  Future<void> _openStoredFile(String path) async {
    final result = await OpenFilex.open(path);
    if (result.type != ResultType.done) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This file could not be opened on this device.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subject =
        _subject ??
        TSubject(
          code: widget.subjectCode,
          name: widget.subjectCode,
          faculty: 'Subject',
          room: 'N/A',
        );

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.background,
        foregroundColor: isDark ? AppColors.darkText : AppColors.lightText,
        elevation: 0,
        title: Text(subject.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.code,
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 0.5,
                        color: isDark
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subject.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Faculty: ${subject.faculty}',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Uploaded notes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _uploadFile,
                    icon: const Icon(Icons.upload_file_rounded),
                    label: const Text('Upload'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _files.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.folder_open_rounded,
                              size: 52,
                              color: isDark
                                  ? AppColors.darkSecondaryText
                                  : AppColors.lightSecondaryText,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'No files uploaded yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tap upload to save notes, PDFs, and resources for this subject.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkSecondaryText
                                    : AppColors.lightSecondaryText,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _files.length,
                        itemBuilder: (context, index) {
                          final file = _files[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurface
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.insert_drive_file_rounded,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        file.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${file.formattedSize} • ${_formatDate(file.modifiedAt)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark
                                              ? AppColors.darkSecondaryText
                                              : AppColors.lightSecondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _openStoredFile(file.path),
                                  tooltip: 'Open file',
                                  icon: const Icon(Icons.open_in_new_rounded),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final fileToDelete = File(file.path);
                                    if (await fileToDelete.exists()) {
                                      await fileToDelete.delete();
                                      await _loadStoreFiles();
                                    }
                                  },
                                  tooltip: 'Delete file',
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$day/$month/${dateTime.year}';
  }
}

class _StoredFile {
  final String name;
  final String path;
  final int size;
  final DateTime modifiedAt;

  const _StoredFile({
    required this.name,
    required this.path,
    required this.size,
    required this.modifiedAt,
  });

  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
