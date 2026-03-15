import 'package:equatable/equatable.dart';
import 'package:task_manager/features/marketing/data/models/marketing_models.dart';

abstract class MarketingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MarketingInitial extends MarketingState {}

class MarketingLoading extends MarketingState {}

class MarketingDashboardLoaded extends MarketingState {
  final MarketingStats stats;
  final List<WorkflowItem> pendingApprovals;
  final List<Campaign> topCampaigns;

  MarketingDashboardLoaded({
    required this.stats,
    required this.pendingApprovals,
    required this.topCampaigns,
  });

  @override
  List<Object?> get props => [stats, pendingApprovals, topCampaigns];
}

class MarketingListLoaded extends MarketingState {
  final List<Campaign> campaigns;
  final String? message;

  MarketingListLoaded({required this.campaigns, this.message});

  @override
  List<Object?> get props => [campaigns, message];
}

class MarketingLeadsLoaded extends MarketingState {
  final List<CampaignLead> leads;
  final String campaignCode;

  MarketingLeadsLoaded({required this.leads, required this.campaignCode});

  @override
  List<Object?> get props => [leads, campaignCode];
}

class MarketingFailure extends MarketingState {
  final String message;
  MarketingFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class MarketingActionSuccess extends MarketingState {
  final String message;
  MarketingActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
