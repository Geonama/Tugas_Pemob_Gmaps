// Nama: Geonama Huda Rahfa
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class HalamanMaps extends StatefulWidget {
  const HalamanMaps({super.key, this.tileProvider});

  final TileProvider? tileProvider;

  @override
  State<HalamanMaps> createState() => _HalamanMapsState();
}

class _HalamanMapsState extends State<HalamanMaps> {
  // Posisi dan zoom awal mengikuti contoh dalam video.
  static const lokasiKampus = LatLng(-6.9720791, 107.6053966);
  final _mapController = MapController();

  void _ubahZoom(double perubahan) {
    final kamera = _mapController.camera;
    final zoom = (kamera.zoom + perubahan).clamp(3.0, 19.0);
    _mapController.move(kamera.center, zoom);
  }

  void _tampilkanInfo() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Telkom University',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('Jl. Telekomunikasi Bandung'),
            const SizedBox(height: 8),
            const Text('-6.9720791, 107.6053966'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps Flutter'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: lokasiKampus,
                initialZoom: 15,
                minZoom: 3,
                maxZoom: 19,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'id.ac.mobile.belajar_maps',
                  tileProvider: widget.tileProvider,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: lokasiKampus,
                      width: 48,
                      height: 48,
                      alignment: Alignment.topCenter,
                      child: IconButton(
                        tooltip: 'Informasi lokasi kampus',
                        padding: EdgeInsets.zero,
                        onPressed: _tampilkanInfo,
                        icon: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 48,
                        ),
                      ),
                    ),
                  ],
                ),
                SimpleAttributionWidget(
                  alignment: Alignment.bottomLeft,
                  source: const Text('OpenStreetMap contributors'),
                  onTap: () => launchUrl(
                    Uri.parse('https://www.openstreetmap.org/copyright'),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                elevation: 2,
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Perbesar peta',
                      onPressed: () => _ubahZoom(1),
                      icon: const Icon(Icons.add),
                    ),
                    IconButton(
                      tooltip: 'Perkecil peta',
                      onPressed: () => _ubahZoom(-1),
                      icon: const Icon(Icons.remove),
                    ),
                    IconButton(
                      tooltip: 'Kembali ke lokasi awal',
                      onPressed: () => _mapController.move(lokasiKampus, 15),
                      icon: const Icon(Icons.my_location),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
