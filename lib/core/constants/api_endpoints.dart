//String baseUrl = 'https://api.rightawayapp.com';
String baseUrl = 'https://cardsandboxbackend.appollondigitals.com/api/request';

class ApiEndpoints {
  static const String loginEndpoint = '/auth/resendLoginOTP';
  static const String verifyLoginOtp = '/auth/verifyOTP';

  static const String signUpEndpoint = '/auth/signUp';
  static const String sendEmailVerificationOTPForSignup =
      '/auth/emailVerificationOTP';
  static const String sendPhoneVerificationOTPForSignup =
      '/auth/phoneVerificationOTP';
  static const String sendEmailVerificationOTPForLogin = '/auth/resendLoginOTP';
  static const String verifyEmailOtpForLogin = '/auth/verifyOTP';
  static const String verifyEmailOTPForSignup = '/auth/verifyEmail';
  static const String verifyPhoneOTPForSignup = '/auth/verifyPhone';
  static const String socialLogin = '/auth/socialRegister';
  static const String socialRegister = '/auth/socialRegister/profile';
  static const String updateFCM = '/auth/updateFCM';
  static const String logout = '/auth/logout';
  static const String delete = '/auth/delete';
  static const String updateProfileEndpoint = '/user/profile';

  //Address Endpoints
  static const String addAddress = "/user/address";
  static const String updateAddress = "/user/address";
  static const String getAddresses = "/user/address/";
  static const String deleteAddress = "/user/address/";

  // Card Endpoints
  static const String addCard = "/user/card";
  static const String updateCard = "/user/card/";
  static const String setDefaultCard = "/user/card/";
  static const String getCard = "/user/card";
  static const String deleteCard = "/user/card/";

  //Products Endpoints
  static const String getBrandProfile = "/user/company/";
  static const String getBrandProducts = "/user/company/";
  static const String getProducts = "/user/products";
  static const String getProductById = "/user/products/";
  static const String favoriteProducts = "/user/products/favorite";
  static const String updateFavorite = "/user/products/favorite";
  static const String similarProduct = "/user//products/";
  static const String priceComparison = "/user//products/";
  static const String orderCreate = "/user/order";
  static const String getReportedProduct = "/user/report";
  static const String getReportedProductDetails = "/user/report/";
  static const String reportProduct = "/user/report/";
  // Delete Account
  static const String sendDeleteAccountOtp = "/auth/emailVerificationOTP";
  static const String verifyDeleteAccountOtp = "/auth/delete";

  // Change Phone Number
  static const String changePhoneNumberEndpoint = "/auth/changeNumber";

  // Notification
  static const String getNotificationSettings = "/user/notification/setting";
  static const String updateNotificationSettings = "/user/notification/setting";

  // Get Orders
  static String getOrders(String status, {int page = 1, int limit = 10}) =>
      "/user/order?status=$status&page=$page&limit=$limit";
  static String getOrderDetails(String orderId) => "/user/order/$orderId";

  // Cancel Order
  static String cancelOrder(String orderId) => "/user/order/$orderId/cancel";

  // Chats Endpoints
  static String getChatRooms({
    required String type,
    required num page,
    required int limit,
  }) {
    return "$baseUrl/chat/?type=$type&page=$page&limit=$limit";
  }
}
