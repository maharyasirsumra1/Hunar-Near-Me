import 'package:flutter/material.dart';

// ============================================================================
// APP DATA MODELS
// ============================================================================

class ServiceCategory {
  final String id;
  final String name;
  final String nameUrdu;
  final IconData icon;
  final Color iconColor;
  bool active;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.nameUrdu,
    required this.icon,
    required this.iconColor,
    this.active = true,
  });
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
}
