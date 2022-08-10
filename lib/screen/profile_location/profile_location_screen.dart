import 'dart:async';

import 'package:e_warung/common/styles.dart';
import 'package:e_warung/screen/profile_location/profile_location_view_model.dart';
import 'package:e_warung/widgets/custom_notification_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../data/model/login_result.dart';
import '../auth/auth_view_model.dart';

class ProfileLocationScreen extends StatefulWidget {
  static const String routeName = '/profile_location';

  const ProfileLocationScreen({Key? key}) : super(key: key);

  @override
  State<ProfileLocationScreen> createState() => _ProfileLocationScreenState();
}

class _ProfileLocationScreenState extends State<ProfileLocationScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  final Map<PolygonId, Polygon> _polygons = <PolygonId, Polygon>{};
  MarkerId? selectedMarker;
  LatLng? markerPosition;

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      CustomNotificationSnackbar(context: context, message: 'Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        CustomNotificationSnackbar(context: context, message: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      CustomNotificationSnackbar(
          context: context,
          message: 'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<void> _goToCurrentLocation() async {
    final ProfileLocationViewModel profileLocationViewModel =
        Provider.of<ProfileLocationViewModel>(context, listen: false);

    final Position position = await profileLocationViewModel.getCurrentLocation();

    _addPlaceMarker(LatLng(position.latitude, position.longitude));
  }

  void _addPlaceMarker(LatLng position) async {
    _markers.clear();
    final int markerCount = _markers.length;

    if (markerCount == 1) {
      return;
    }

    final ProfileLocationViewModel profileLocationViewModel =
        Provider.of<ProfileLocationViewModel>(context, listen: false);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark address = placemarks.first;
    String addressName = address.name != null && address.name!.isNotEmpty ? "${address.name}" : "";
    String addressThoroughfare = address.thoroughfare != null && address.thoroughfare!.isNotEmpty
        ? ", ${address.thoroughfare}"
        : "";
    String addressSubLocality = address.subLocality != null && address.subLocality!.isNotEmpty
        ? ", ${address.subLocality}"
        : "";
    String addressLocality =
        address.locality != null && address.locality!.isNotEmpty ? ", ${address.locality}" : "";

    if (address.subLocality != profileLocationViewModel.subLocalityName ||
        address.locality != profileLocationViewModel.localityName) {
      profileLocationViewModel.setPopUpMessage("Lokasi tidak dalam jangkauan");
      profileLocationViewModel.clearCurrentLocation();
      return;
    }

    final String markerIdVal =
        "$addressName$addressThoroughfare$addressSubLocality$addressLocality";
    final MarkerId markerId = MarkerId(markerIdVal);

    profileLocationViewModel.setCurrentLocation(markerIdVal, position.latitude, position.longitude);

    final Marker marker = Marker(
      markerId: markerId,
      position: position,
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () => _onMarkerTapped(markerId),
    );

    setState(() {
      _markers[markerId] = marker;
    });

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 20.4746,
    )));
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker? tappedMarker = _markers[markerId];

    if (tappedMarker != null) {
      setState(() {
        final MarkerId? previousMarkerId = selectedMarker;
        if (previousMarkerId != null && _markers.containsKey(previousMarkerId)) {
          final Marker resetOld =
              _markers[previousMarkerId]!.copyWith(iconParam: BitmapDescriptor.defaultMarker);
          _markers[previousMarkerId] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        _markers[markerId] = newMarker;

        markerPosition = null;
      });
    }
  }

  void _addArea() async {
    _polygons.clear();
    final int areaCount = _polygons.length;

    if (areaCount == 1) {
      return;
    }

    List<LatLng> polygonLatLongs = [];
    polygonLatLongs.add(const LatLng(-6.926920, 111.378571));
    polygonLatLongs.add(const LatLng(-6.926955, 111.382761));
    polygonLatLongs.add(const LatLng(-6.930598, 111.388644));
    polygonLatLongs.add(const LatLng(-6.924538, 111.390632));
    polygonLatLongs.add(const LatLng(-6.925261, 111.394273));
    polygonLatLongs.add(const LatLng(-6.948160, 111.393384));
    polygonLatLongs.add(const LatLng(-6.945795, 111.378525));
    polygonLatLongs.add(const LatLng(-6.936195, 111.375918));
    polygonLatLongs.add(const LatLng(-6.935335, 111.366427));
    polygonLatLongs.add(const LatLng(-6.936732, 111.364803));
    polygonLatLongs.add(const LatLng(-6.934618, 111.358885));
    polygonLatLongs.add(const LatLng(-6.932397, 111.358307));
    polygonLatLongs.add(const LatLng(-6.929567, 111.351848));
    polygonLatLongs.add(const LatLng(-6.921364, 111.354338));
    polygonLatLongs.add(const LatLng(-6.921614, 111.357405));
    polygonLatLongs.add(const LatLng(-6.923477, 111.358524));
    polygonLatLongs.add(const LatLng(-6.924409, 111.364550));
    polygonLatLongs.add(const LatLng(-6.928815, 111.366138));
    polygonLatLongs.add(const LatLng(-6.925842, 111.372021));
    polygonLatLongs.add(const LatLng(-6.927775, 111.375462));
    polygonLatLongs.add(const LatLng(-6.927700, 111.377359));

    const String polygonIdVal = 'polygon_id_1';
    const PolygonId polygonId = PolygonId(polygonIdVal);

    final Polygon polygon = Polygon(
      polygonId: polygonId,
      points: polygonLatLongs,
      strokeColor: Colors.blue.withOpacity(0.5),
      fillColor: Colors.blue.withOpacity(0.1),
      strokeWidth: 2,
    );

    setState(() {
      _polygons[polygonId] = polygon;
    });
  }

  @override
  void initState() {
    _addArea();
    _determinePosition();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final AuthViewModel authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final User user = authViewModel.userLogin;

      if (user.latitude != null && user.longitude != null) {
        _addPlaceMarker(LatLng(double.parse(user.latitude!), double.parse(user.longitude!)));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location"),
      ),
      body: SafeArea(
        child: Consumer<ProfileLocationViewModel>(builder: (context, model, child) {
          return Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(model.initialLatitude, model.initialLongitude),
                  zoom: 13.5746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onTap: (position) async {
                  _addPlaceMarker(position);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                markers: Set<Marker>.of(_markers.values),
                polygons: Set<Polygon>.of(_polygons.values),
              ),
              if (model.popUpMessage.isNotEmpty)
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      model.popUpMessage,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: textColorWhite,
                          ),
                    ),
                  ),
                )
            ],
          );
        }),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
              left: 30,
              bottom: 20,
              child: FloatingActionButton.extended(
                onPressed: _goToCurrentLocation,
                label: Text(
                  'Lokasi saya',
                  style: Theme.of(context).textTheme.button!.copyWith(
                        color: textColorWhite,
                      ),
                ),
                icon: const Icon(Icons.my_location),
              )),
          Positioned(
            bottom: 20,
            right: 30,
            child: FloatingActionButton.extended(
              onPressed: () {
                final ProfileLocationViewModel profileLocationViewModel =
                    Provider.of<ProfileLocationViewModel>(context, listen: false);

                Navigator.pop(context, {
                  "address": profileLocationViewModel.currentNamePosition,
                  "latitude": profileLocationViewModel.currentLatitude,
                  "longitude": profileLocationViewModel.currentLongitude,
                });
              },
              label: Text(
                'Set Location',
                style: Theme.of(context).textTheme.button!.copyWith(
                      color: textColorWhite,
                    ),
              ),
              icon: const Icon(Icons.add_location_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
