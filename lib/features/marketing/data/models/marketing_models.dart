import 'package:equatable/equatable.dart';

enum CampaignStatus { draft, pending, approved, launched }

class Campaign extends Equatable {
  final String id;
  final String code;
  final String name;
  final CampaignStatus status;
  final double totalBudget;
  final double actualSpend;
  final DateTime startDate;
  final DateTime endDate;
  final String description;

  const Campaign({
    required this.id,
    required this.code,
    required this.name,
    required this.status,
    required this.totalBudget,
    required this.actualSpend,
    required this.startDate,
    required this.endDate,
    this.description = '',
  });

  Campaign copyWith({
    String? id,
    String? code,
    String? name,
    CampaignStatus? status,
    double? totalBudget,
    double? actualSpend,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
  }) {
    return Campaign(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      status: status ?? this.status,
      totalBudget: totalBudget ?? this.totalBudget,
      actualSpend: actualSpend ?? this.actualSpend,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, code, name, status, totalBudget, actualSpend, startDate, endDate];
}

class CampaignLead extends Equatable {
  final String id;
  final String campaignCode;
  final String name;
  final String contact;
  final DateTime date;

  const CampaignLead({
    required this.id,
    required this.campaignCode,
    required this.name,
    required this.contact,
    required this.date,
  });

  @override
  List<Object?> get props => [id, campaignCode, name, contact, date];
}

class MarketingStats extends Equatable {
  final int draftCount;
  final int pendingCount;
  final int approvedCount;
  final int launchedCount;

  const MarketingStats({
    required this.draftCount,
    required this.pendingCount,
    required this.approvedCount,
    required this.launchedCount,
  });

  @override
  List<Object?> get props => [draftCount, pendingCount, approvedCount, launchedCount];
}

class WorkflowItem extends Equatable {
  final String id;
  final String campaignId;
  final String campaignName;
  final String requesterName;
  final DateTime requestDate;

  const WorkflowItem({
    required this.id,
    required this.campaignId,
    required this.campaignName,
    required this.requesterName,
    required this.requestDate,
  });

  @override
  List<Object?> get props => [id, campaignId, campaignName, requesterName, requestDate];
}
