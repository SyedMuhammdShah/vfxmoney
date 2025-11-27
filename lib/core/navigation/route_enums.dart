// lib/core/constants/route_enums.dart

enum Routes {
  root("/"),
  //  Auth Routes
  login('/login'),
  signUp('/signUp'),
  otp('/otp'),
  onboarding('/onboarding'),
  loginSuccess('/loginSuccess'),
  forgotPass('/forgotPass'),
  changePass('/changePass'),
  verifyAccount('/verifyAccount'),
  signUpSuccess('/signUpSuccess'),

  // --- MAIN SHELL ---
  dashboard('/dashboard'),
  myCard('/myCard'),
  transactions('/transactions'),
  profile('/profile'),

  // Settings
  settings('/settings'),
  feesAndLimit('/feesAndLimit'),

  // Profile
  userProfile('/userProfile'),

  enableLocationScreen('/enableLocationScreen'),
  addressSelection('/addressSelection'),
  addAddress('/addAddress'),
  deleteAccount('/deleteAccount'),
  deleteOtp('/deleteOtp'),
  deleteAccountSuccess('/deleteAccountSuccess'),
  reportIssueSuccess('/reportIssueSuccess'),
  socialProfileSetupScreen('/SocialProfileSetupScreen'),
  socialProifleOTP('/socialProifleOTP'),

  createProfile('/createProfile'),
  editProfile('/editProfile'),
  academicInfo('/academicInfo'),
  addSkills('/addInter'),
  addInterests('/addInterests'),
  addServices('/addServices'),
  addTimeSlots('/addTimeSlots'),
  paymentMethod('/paymentMethod'),
  addPaymentCardScreen('/addPaymentCardScreen'),
  cardSuccess('/cardSuccess'),

  events('/events'),
  event('/event'),
  checkout('/checkout'),

  notification('/notification'),
  qr('/qr'),

  //Chats
  chats('/chats'),

  connection('/connection'),

  //Products
  homeProducts('/homeProducts'),
  productDetails('/productDetails'),
  reviews('/reviews'),
  similarProduct('/similarProduct'),
  moreFromThisSupplier('/moreFromThisSupplier'),
  favoriteProduct('/favoriteProduct'),
  reportedProduct('/reportedProduct'),
  reportedDetails('/reportedDetails'),
  priceCompare('/priceCompare'),
  notificationToogle('/notificationToogle'),
  changePhoneNumber('/changePhoneNumber'),
  changePhoneNumberSuccess('/changePhoneNumberSuccess'),
  addToCart('/addToCart'),
  storeSelection('/storeSelection'),
  orderType('/orderType'),
  schedule('/schedule'),
  orderReview('/orderReview'),
  brandProfile('/brandProfile'),

  leaderboard('/leaderboard'),
  search('/search'),
  services('/services'),

  // Settings
  blockAccounts('/blockAccounts'),
  paymentDetails('/paymentDetails'),
  addCard('/addCard'),
  accountPrivacy('/accountPrivacy'),
  changeEmail('/changeEmail'),
  changePassword('/changePassword'),
  privacyPolicy('/privacyPolicy'),
  termsConditions('/termsConditions'),
  wallet('/wallet'),
  withdrawScreen('/withdraw'),

  //Order

  orderDetails('/orderDetails'),
  orderTrackingScreen('/orderTrackingScreen'),
  trackOrder("/trackOrder"),
  reportReasonScreen("/ReportReasonScreen"),
  orderCancel('/orderCancel');

  final String path;
  const Routes(this.path);
}
