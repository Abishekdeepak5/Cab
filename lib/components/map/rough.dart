  // Future<bool> updateCameraBounds(BuildContext context) async {
  //   try{
  //     _destinationMarker = _destinationMarker.copyWith(
  //                                       positionParam: LatLng(currentLocation!.latitude, currentLocation!.longitude), // Default destination location
  //     );
  //     LatLngBounds bounds = LatLngBounds(
  //   southwest: LatLng(
  //     _sourceMarker.position.latitude < _destinationMarker.position.latitude
  //         ? _sourceMarker.position.latitude
  //         : _destinationMarker.position.latitude,
  //     _sourceMarker.position.longitude < _destinationMarker.position.longitude
  //         ? _sourceMarker.position.longitude
  //         : _destinationMarker.position.longitude,
  //   ),
  //   northeast: LatLng(
  //     _sourceMarker.position.latitude > _destinationMarker.position.latitude
  //         ? _sourceMarker.position.latitude
  //         : _destinationMarker.position.latitude,
  //     _sourceMarker.position.longitude > _destinationMarker.position.longitude
  //         ? _sourceMarker.position.longitude
  //         : _destinationMarker.position.longitude,
  //   ),
  // );
  //   CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(
  //     bounds,
  //     100.0, );
  //   googleMapController = await _mapController.future;
  //   googleMapController?.animateCamera(cameraUpdate);
  //   }catch(err){
  //     PopUpMessage.displayMessage(context, '$err', 3);
  //       return false;
  //   }

  //   return true;
  // }
