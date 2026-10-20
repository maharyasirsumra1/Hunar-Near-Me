import 'package:flutter/material.dart';

// ============================================================================
// APP DATA MODELS
// ============================================================================

class ServiceCategory {
  final String id;
  final String name;
  final String nameUrdu;
  final String imageAsset;
  final IconData icon;
  final Color iconColor;
  bool active;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.nameUrdu,
    required this.imageAsset,
    required this.icon,
    required this.iconColor,
    this.active = true,
  });

  Map<String, dynamic> toJson() => {'id': id, 'active': active};
}

class LocationItem {
  final String id;
  final String name;
  final String kind; // 'province', 'city', 'area'
  final String? parentId;

  LocationItem({
    required this.id,
    required this.name,
    required this.kind,
    this.parentId,
  });

  Map<String, dynamic> toJson() => {'id': id};
}

class WorkerProfile {
  final String id;
  final String name;
  final String phone;
  final List<String> serviceIds;
  final String provinceId;
  final String cityId;
  final String areaId;
  final double distanceKm;
  final double ratingAverage;
  final int ratingCount;
  final int completedJobs;
  final int experienceYears;
  final String bio;
  final bool verifiedBadge;
  String approvalStatus; // 'PENDING', 'APPROVED', 'REJECTED'
  String? paymentMethod;
  String? transactionRef;
  String? paymentStatus; // 'PENDING', 'VERIFIED', 'REJECTED'

  WorkerProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.serviceIds,
    required this.provinceId,
    required this.cityId,
    required this.areaId,
    required this.distanceKm,
    required this.ratingAverage,
    required this.ratingCount,
    required this.completedJobs,
    required this.experienceYears,
    required this.bio,
    this.verifiedBadge = true,
    this.approvalStatus = 'APPROVED',
    this.paymentMethod,
    this.transactionRef,
    this.paymentStatus = 'VERIFIED',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'serviceIds': serviceIds,
        'provinceId': provinceId,
        'cityId': cityId,
        'areaId': areaId,
        'distanceKm': distanceKm,
        'ratingAverage': ratingAverage,
        'ratingCount': ratingCount,
        'completedJobs': completedJobs,
        'experienceYears': experienceYears,
        'bio': bio,
        'verifiedBadge': verifiedBadge,
        'approvalStatus': approvalStatus,
        'paymentMethod': paymentMethod,
        'transactionRef': transactionRef,
        'paymentStatus': paymentStatus,
      };

  factory WorkerProfile.fromJson(Map<String, dynamic> json) => WorkerProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        serviceIds: List<String>.from(json['serviceIds'] as List),
        provinceId: json['provinceId'] as String,
        cityId: json['cityId'] as String,
        areaId: json['areaId'] as String,
        distanceKm: (json['distanceKm'] as num).toDouble(),
        ratingAverage: (json['ratingAverage'] as num).toDouble(),
        ratingCount: json['ratingCount'] as int,
        completedJobs: json['completedJobs'] as int,
        experienceYears: json['experienceYears'] as int,
        bio: json['bio'] as String,
        verifiedBadge: json['verifiedBadge'] as bool? ?? false,
        approvalStatus: json['approvalStatus'] as String? ?? 'PENDING',
        paymentMethod: json['paymentMethod'] as String?,
        transactionRef: json['transactionRef'] as String?,
        paymentStatus: json['paymentStatus'] as String?,
      );
}

class JobBooking {
  final String id;
  final String customerName;
  final String workerId;
  final String serviceName;
  final String description;
  final int proposedPricePkr;
  int? quotedPricePkr;
  final String address;
  String status; // 'PENDING', 'QUOTED', 'ACCEPTED', 'COMPLETED'
  final DateTime createdAt;
  int? ratingGiven;
  String? reviewComment;

  JobBooking({
    required this.id,
    required this.customerName,
    required this.workerId,
    required this.serviceName,
    required this.description,
    required this.proposedPricePkr,
    this.quotedPricePkr,
    required this.address,
    required this.status,
    required this.createdAt,
    this.ratingGiven,
    this.reviewComment,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'workerId': workerId,
        'serviceName': serviceName,
        'description': description,
        'proposedPricePkr': proposedPricePkr,
        'quotedPricePkr': quotedPricePkr,
        'address': address,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'ratingGiven': ratingGiven,
        'reviewComment': reviewComment,
      };

  factory JobBooking.fromJson(Map<String, dynamic> json) => JobBooking(
        id: json['id'] as String,
        customerName: json['customerName'] as String,
        workerId: json['workerId'] as String,
        serviceName: json['serviceName'] as String,
        description: json['description'] as String,
        proposedPricePkr: json['proposedPricePkr'] as int,
        quotedPricePkr: json['quotedPricePkr'] as int?,
        address: json['address'] as String,
        status: json['status'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        ratingGiven: json['ratingGiven'] as int?,
        reviewComment: json['reviewComment'] as String?,
      );
}
