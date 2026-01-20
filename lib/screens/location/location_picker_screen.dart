import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

class LocationPickerScreen extends StatefulWidget {
  final double initialLat;
  final double initialLng;

  const LocationPickerScreen({
    super.key,
    this.initialLat = -6.200000, // Default Jakarta
    this.initialLng = 106.816666,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late MapController _mapController;
  late LatLng _currentCenter;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String _address = '';
  bool _hasInitialLocation = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // 1. Set initial center from arguments OR default Jakarta
    double lat = widget.initialLat;
    double lng = widget.initialLng;

    // Check if arguments are effectively "empty" (0.0)
    if (lat == 0 && lng == 0) {
      lat = -6.200000;
      lng = 106.816666;
    }

    _currentCenter = LatLng(lat, lng);
    _hasInitialLocation = true; // Show map immediately with whatever we have

    // 2. ALWAYS try to get current GPS location to update map center
    // This satisfies "lokasi mengikuti lokasi user saat ini"
    _getCurrentLocation();

    // 3. Reverse geocode the initial point just in case
    _getAddressFromLatLng(_currentCenter);
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    setState(() => _isLoading = true);

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Error', 'Location services are disabled.');
        setState(() => _hasInitialLocation = true); // Fallback to default
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Location permissions are denied');
          setState(() => _hasInitialLocation = true); // Fallback
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Error', 'Location permissions are permanently denied.');
        setState(() => _hasInitialLocation = true); // Fallback
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final newPos = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentCenter = newPos;
        _hasInitialLocation = true;
      });
      _mapController.move(newPos, 15.0);
      _getAddressFromLatLng(newPos);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
      setState(() => _hasInitialLocation = true); // Fallback
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;
    setState(() => _isLoading = true);

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1',
    );
    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'TailorAdminApp/1.0'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          final newPos = LatLng(lat, lon);

          setState(() {
            _currentCenter = newPos;
          });
          _mapController.move(newPos, 15.0);
          _getAddressFromLatLng(newPos);

          // Clear search focus
          FocusManager.instance.primaryFocus?.unfocus();
        } else {
          Get.snackbar('Info', 'Lokasi tidak ditemukan');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mencari lokasi: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng latlng) async {
    // Only reverse geocode if not dragging excessively to avoid spamming API
    // For now, we call this on search or confirm or init.
    // In build, onPositionChanged, we update center but maybe delay address fetch?
    // Let's fetch address only when needed or "debounced".
    // For this requirements ("saat pilih titik lewat map alamat juga otomatis terisi"),
    // it implies when we confirm or when we stop moving.
    // Let's do it simply: Fetch when movement stops is tricky without debounce.
    // We will just fetch it now and use it.

    // NOTE: Nominatim has rate limits (1 request/sec).

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?lat=${latlng.latitude}&lon=${latlng.longitude}&format=json',
    );

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'TailorAdminApp/1.0'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _address = data['display_name'] ?? 'Alamat tidak ditemukan';
        });
      }
    } catch (e) {
      debugPrint('Error reverse geocoding: $e');
    }
  }

  void _onConfirm() {
    Get.back(result: {'latlng': _currentCenter, 'address': _address});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Prevent map resize/distortion on keyboard
      appBar: AppBar(
        title: Text(
          'Pilih Lokasi',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: !_hasInitialLocation
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Mencari lokasi anda..."),
                ],
              ),
            )
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentCenter,
                    initialZoom: 15.0,
                    onPositionChanged: (position, hasGesture) {
                      if (position.center != null) {
                        _currentCenter = position.center!;
                        // We don't fetch address continuously here to avoid rate limit
                      }
                    },
                    // When map stops moving (interaction ends), we could fetch address
                    onMapEvent: (event) {
                      if (event is MapEventMoveEnd) {
                        _getAddressFromLatLng(event.camera.center);
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.tailor.admin.app',
                    ),
                  ],
                ),

                // Search Bar
                Positioned(
                  top: 16,
                  left: 20,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: _searchLocation,
                      decoration: InputDecoration(
                        hintText: 'Cari lokasi (cth: Monas, Jakarta)...',
                        hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14),
                        prefixIcon: const Icon(Iconsax.search_normal),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),

                // Loading Indicator
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),

                // Fixed Center Pin
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 50,
                    ), // Adjust for pin anchor
                    child: Icon(
                      Icons.location_on,
                      color: Color(0xFF3F51B5),
                      size: 50,
                    ),
                  ),
                ),

                // Address Preview & Confirm Button
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // My Location Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: _getCurrentLocation,
                            child: const Icon(
                              Iconsax.gps,
                              color: Color(0xFF3F51B5),
                            ),
                          ),
                        ),
                      ),

                      // Info Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_address.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Iconsax.location,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _address,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: Colors.grey[800],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ElevatedButton(
                              onPressed: _onConfirm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3F51B5),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Konfirmasi Lokasi Ini',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
