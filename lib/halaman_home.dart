import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'halaman_maps.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.tileProvider});

  final TileProvider? tileProvider;

  void _bukaMaps(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => HalamanMaps(tileProvider: tileProvider),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Belajar Flutter')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Card.outlined(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: const Icon(Icons.map, color: Colors.blue, size: 32),
                title: const Text('Peta Kampus'),
                subtitle: const Text('Lihat peta lokasi Telkom University'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _bukaMaps(context),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: FilledButton.icon(
                onPressed: () => _bukaMaps(context),
                icon: const Icon(Icons.location_on),
                label: const Text('Buka Maps'),
                style: FilledButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
