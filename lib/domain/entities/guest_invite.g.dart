// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GuestInviteImpl _$$GuestInviteImplFromJson(Map<String, dynamic> json) =>
    _$GuestInviteImpl(
      id: json['id'] as String,
      profileId: json['profileId'] as String,
      token: json['token'] as String,
      label: json['label'] as String? ?? '',
      createdAt: (json['createdAt'] as num).toInt(),
      expiresAt: (json['expiresAt'] as num?)?.toInt(),
      isRevoked: json['isRevoked'] as bool? ?? false,
      lastSeenAt: (json['lastSeenAt'] as num?)?.toInt(),
      activeDeviceId: json['activeDeviceId'] as String?,
    );

Map<String, dynamic> _$$GuestInviteImplToJson(_$GuestInviteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profileId': instance.profileId,
      'token': instance.token,
      'label': instance.label,
      'createdAt': instance.createdAt,
      'expiresAt': instance.expiresAt,
      'isRevoked': instance.isRevoked,
      'lastSeenAt': instance.lastSeenAt,
      'activeDeviceId': instance.activeDeviceId,
    };
