class OrderConstants {
  // ✅ Exact backend status values (case-sensitive!)
  static const String statusInProcess = 'inprocess';
  static const String statusInTransit = 'inTransit';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';
  
  // UI Tab titles
  static const String tabInProgress = 'In Progress';
  static const String tabCompleted = 'Completed';
  static const String tabCancelled = 'Cancelled';
  
  // Pagination
  static const int defaultLimit = 10;
}