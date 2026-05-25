import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/exercise.dart';
import '../services/storage_service.dart';

class GarminScreen extends StatefulWidget {
  const GarminScreen({super.key});

  @override
  State<GarminScreen> createState() => _GarminScreenState();
}

class _GarminScreenState extends State<GarminScreen> {
  StorageService? _store;
  List<GarminScreenshot> _shots = [];
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final s = await StorageService.create();
    if (!mounted) return;
    setState(() {
      _store = s;
      _shots = s.getGarmin();
    });
  }

  Future<void> _pick() async {
    setState(() => _uploading = true);
    try {
      final picker = ImagePicker();
      final XFile? file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1080,
      );
      if (file == null) return;

      final bytes = await file.readAsBytes();
      final compressed = await _compress(bytes);
      final shot = GarminScreenshot(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        dateIso: DateTime.now().toIso8601String(),
        label: '',
        base64Jpeg: base64Encode(compressed),
      );
      await _store!.addGarmin(shot);
      if (!mounted) return;
      setState(() => _shots = _store!.getGarmin());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error subiendo: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<Uint8List> _compress(Uint8List input) async {
    final decoded = img.decodeImage(input);
    if (decoded == null) return input;
    final resized = decoded.width > 1080
        ? img.copyResize(decoded, width: 1080)
        : decoded;
    return Uint8List.fromList(img.encodeJpg(resized, quality: 75));
  }

  Future<void> _delete(String id) async {
    await _store!.deleteGarmin(id);
    if (!mounted) return;
    setState(() => _shots = _store!.getGarmin());
  }

  void _preview(GarminScreenshot s) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(8),
        child: InteractiveViewer(
          child: Image.memory(base64Decode(s.base64Jpeg)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_store == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Garmin Upload'),
        actions: [
          if (_shots.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Text(
                  '${_shots.length}/${StorageService.garminMax}',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_a_photo),
                label: Text(_uploading ? 'Procesando…' : 'Subir captura'),
                onPressed: _uploading ? null : _pick,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: _shots.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Sin capturas todavía.\nSube screenshots de Garmin Connect '
                          'para guardarlas localmente.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: _shots.length,
                      itemBuilder: (context, i) {
                        final s = _shots[i];
                        final d = DateTime.tryParse(s.dateIso);
                        final dateText = d == null
                            ? s.dateIso
                            : DateFormat('d MMM HH:mm', 'es').format(d);
                        return GestureDetector(
                          onTap: () => _preview(s),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.memory(
                                  base64Decode(s.base64Jpeg),
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    color: Colors.black54,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            dateText,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => _delete(s.id),
                                          child: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
