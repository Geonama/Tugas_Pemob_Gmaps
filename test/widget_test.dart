import 'dart:convert';

import 'package:belajar_maps/halaman_home.dart';
import 'package:belajar_maps/halaman_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

class TileUntukTes extends TileProvider {
  final _gambar = MemoryImage(
    base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGNgYGBgAAAABQABpfZFQAAAAABJRU5ErkJggg==',
    ),
  );

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) =>
      _gambar;
}

void main() {
  testWidgets('Menu dan tombol membuka peta lalu dapat kembali', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: HomePage(tileProvider: TileUntukTes())),
    );
    await tester.tap(find.text('Peta Kampus'));
    await tester.pumpAndSettle();
    expect(find.text('Maps Flutter'), findsOneWidget);
    expect(find.byType(FlutterMap), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Belajar Flutter'), findsOneWidget);

    await tester.tap(find.text('Buka Maps'));
    await tester.pumpAndSettle();
    expect(find.byType(FlutterMap), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Zoom, posisi awal, dan informasi marker berfungsi', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: HalamanMaps(tileProvider: TileUntukTes())),
    );
    await tester.pumpAndSettle();

    final peta = tester.widget<FlutterMap>(find.byType(FlutterMap));
    final controller = peta.mapController!;
    expect(controller.camera.zoom, 15);

    await tester.tap(find.byTooltip('Perbesar peta'));
    await tester.pumpAndSettle();
    expect(controller.camera.zoom, 16);

    await tester.tap(find.byTooltip('Perkecil peta'));
    await tester.pumpAndSettle();
    expect(controller.camera.zoom, 15);

    controller.move(const LatLng(-6.95, 107.62), 12);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Kembali ke lokasi awal'));
    await tester.pumpAndSettle();
    expect(controller.camera.zoom, 15);
    expect(controller.camera.center, const LatLng(-6.9720791, 107.6053966));

    await tester.tap(find.byTooltip('Informasi lokasi kampus'));
    await tester.pumpAndSettle();
    expect(find.text('Telkom University'), findsOneWidget);
    expect(find.text('Jl. Telekomunikasi Bandung'), findsOneWidget);

    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    expect(find.text('Telkom University'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
