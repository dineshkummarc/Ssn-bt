import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageController extends GetxController {
  late SharedPreferences _prefs;

  var isHosteller = false.obs;
  var routeIndex = 0.obs;
  var stopIndex = 0.obs;
  @override
  void onInit() {
    getInstance();
    super.onInit();
  }

  void getInstance() async {
    _prefs = await SharedPreferences.getInstance();
    isHosteller.value = _prefs.getBool('isHosteller') ?? false;
    routeIndex.value = _prefs.getInt('routeIndex') ?? 0;
    stopIndex.value = _prefs.getInt('stopIndex') ?? 0;
  }

  void setHosteller(bool setHostellerBool) {
    isHosteller.value = setHostellerBool;
    _prefs.setBool('isHosteller', setHostellerBool);
  }

  void setRouteIndex(int setRouteIndex) {
    routeIndex.value = setRouteIndex;
    _prefs.setInt('routeIndex', setRouteIndex);
  }

  void setStopIndex(int setStopIndex) {
    stopIndex.value = setStopIndex;
    _prefs.setInt('stopIndex', setStopIndex);
  }
}
