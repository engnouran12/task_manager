import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/marketing/data/services/mock_marketing_service.dart';
import 'package:task_manager/features/marketing/presentation/view_model/marketing_state.dart';

class MarketingCubit extends Cubit<MarketingState> {
  final MarketingRepository _repository;

  MarketingCubit(this._repository) : super(MarketingInitial());

  Future<void> loadDashboard() async {
    emit(MarketingLoading());
    try {
      final statsRes = await _repository.getMarketingStats();
      final approvalsRes = await _repository.getPendingApprovals();
      final campaignsRes = await _repository.getCampaigns();

      if (statsRes.success && approvalsRes.success && campaignsRes.success) {
        emit(MarketingDashboardLoaded(
          stats: statsRes.data!,
          pendingApprovals: approvalsRes.data!,
          topCampaigns: campaignsRes.data!.take(3).toList(),
        ));
      } else {
        emit(MarketingFailure('Failed to load dashboard data'));
      }
    } catch (e) {
      emit(MarketingFailure(e.toString()));
    }
  }

  Future<void> loadCampaigns() async {
    emit(MarketingLoading());
    try {
      final res = await _repository.getCampaigns();
      if (res.success) {
        emit(MarketingListLoaded(campaigns: res.data!));
      } else {
        emit(MarketingFailure(res.message));
      }
    } catch (e) {
      emit(MarketingFailure(e.toString()));
    }
  }

  Future<void> submitCampaign(String id) async {
    try {
      final res = await _repository.submitCampaign(id);
      if (res.success) {
        loadCampaigns(); // Refresh list
      } else {
        emit(MarketingFailure(res.message));
      }
    } catch (e) {
      emit(MarketingFailure(e.toString()));
    }
  }

  Future<void> approveCampaign(String id) async {
    try {
      final res = await _repository.approveCampaign(id);
      if (res.success) {
        loadDashboard(); // Refresh dashboard if approved from there
      } else {
        emit(MarketingFailure(res.message));
      }
    } catch (e) {
      emit(MarketingFailure(e.toString()));
    }
  }

  Future<void> duplicateCampaign(String id) async {
    emit(MarketingLoading());
    try {
      final res = await _repository.duplicateCampaign(id);
      if (res.success) {
        loadCampaigns(); 
      } else {
        emit(MarketingFailure(res.message));
      }
    } catch (e) {
      emit(MarketingFailure(e.toString()));
    }
  }

  Future<void> viewLeads(String campaignCode) async {
    emit(MarketingLoading());
    try {
      final res = await _repository.getLeads(campaignCode);
      if (res.success) {
        emit(MarketingLeadsLoaded(leads: res.data!, campaignCode: campaignCode));
      } else {
        emit(MarketingFailure(res.message));
      }
    } catch (e) {
      emit(MarketingFailure(e.toString()));
    }
  }
}
