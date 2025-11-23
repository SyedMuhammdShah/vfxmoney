import 'package:dio/dio.dart';
import 'package:vfxmoney/core/navigation/app_router.dart';
import 'package:vfxmoney/core/services/service_locator.dart';
import 'package:vfxmoney/core/services/storage_service.dart';

import '../navigation/route_enums.dart';

class AuthInterceptor extends Interceptor {
  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   super.onResponse(response, handler);
  // }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      locator<StorageService>().clear();
      AppRouter.router.goNamed(Routes.login.name);
    }
    super.onError(err, handler);
  }
}
