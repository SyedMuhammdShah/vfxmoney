// class NotificationSettingsEntity {
//   final bool events;
//   final bool groups;
//   final bool chats;
//   final bool connections;
//   final bool badges;

//   NotificationSettingsEntity({
//     required this.events,
//     required this.groups,
//     required this.chats,
//     required this.connections,
//     required this.badges,
//   });

//   NotificationSettingsEntity copyWith({
//     bool? events,
//     bool? groups,
//     bool? chats,
//     bool? connections,
//     bool? badges,
//   }) {
//     return NotificationSettingsEntity(
//       events: events ?? this.events,
//       groups: groups ?? this.groups,
//       chats: chats ?? this.chats,
//       connections: connections ?? this.connections,
//       badges: badges ?? this.badges,
//     );
//   }
// }
// extension NotificationSettingsEntityExt on NotificationSettingsEntity {
//   NotificationSettingsEntity copyWithByKey({
//     required String key,
//     required bool value,
//   }) {
//     switch (key) {
//       case 'events':
//         return copyWith(events: value);
//       case 'groups':
//         return copyWith(groups: value);
//       case 'chats':
//         return copyWith(chats: value);
//       case 'connections':
//         return copyWith(connections: value);
//       case 'badges':
//         return copyWith(badges: value);
//       default:
//         return this;
//     }
//   }
// }
