import 'package:task_manager/core/models/api_response.dart';
import 'package:task_manager/features/marketing/data/models/marketing_models.dart';

class MarketingRepository {
  final List<Campaign> _campaigns = [
    Campaign(
      id: '1',
      code: 'CMP-001',
      name: 'Summer Wellness 2026',
      status: CampaignStatus.launched,
      totalBudget: 50000.0,
      actualSpend: 32000.0,
      startDate: DateTime(2026, 6, 1),
      endDate: DateTime(2026, 8, 31),
      description: 'Promoting summer health packages.',
    ),
    Campaign(
      id: '2',
      code: 'CMP-002',
      name: 'Ramadan Care',
      status: CampaignStatus.approved,
      totalBudget: 25000.0,
      actualSpend: 0.0,
      startDate: DateTime(2026, 3, 1),
      endDate: DateTime(2026, 3, 30),
    ),
    Campaign(
      id: '3',
      code: 'CMP-003',
      name: 'New Branch Opening',
      status: CampaignStatus.pending,
      totalBudget: 100000.0,
      actualSpend: 15000.0,
      startDate: DateTime(2026, 4, 1),
      endDate: DateTime(2026, 5, 1),
    ),
    Campaign(
      id: '4',
      code: 'CMP-004',
      name: 'Diabetes Awareness',
      status: CampaignStatus.draft,
      totalBudget: 15000.0,
      actualSpend: 0.0,
      startDate: DateTime(2026, 11, 1),
      endDate: DateTime(2026, 11, 14),
    ),
  ];

  final List<WorkflowItem> _workflowItems = [
    WorkflowItem(
      id: 'w1',
      campaignId: '3',
      campaignName: 'New Branch Opening',
      requesterName: 'Sarah J.',
      requestDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Future<ApiResponse<List<Campaign>>> getCampaigns() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return ApiResponse.success(_campaigns);
  }

  Future<ApiResponse<MarketingStats>> getMarketingStats() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final stats = MarketingStats(
      draftCount: _campaigns.where((c) => c.status == CampaignStatus.draft).length,
      pendingCount: _campaigns.where((c) => c.status == CampaignStatus.pending).length,
      approvedCount: _campaigns.where((c) => c.status == CampaignStatus.approved).length,
      launchedCount: _campaigns.where((c) => c.status == CampaignStatus.launched).length,
    );
    return ApiResponse.success(stats);
  }

  Future<ApiResponse<List<WorkflowItem>>> getPendingApprovals() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ApiResponse.success(_workflowItems);
  }

  Future<ApiResponse<bool>> submitCampaign(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _campaigns.indexWhere((c) => c.id == id);
    if (index != -1) {
      _campaigns[index] = _campaigns[index].copyWith(status: CampaignStatus.pending);
      return ApiResponse.success(true);
    }
    return ApiResponse.error('Campaign not found');
  }

  Future<ApiResponse<bool>> approveCampaign(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _campaigns.indexWhere((c) => c.id == id);
    if (index != -1) {
      _campaigns[index] = _campaigns[index].copyWith(status: CampaignStatus.approved);
      _workflowItems.removeWhere((w) => w.campaignId == id);
      return ApiResponse.success(true);
    }
    return ApiResponse.error('Campaign not found');
  }

  Future<ApiResponse<Campaign>> duplicateCampaign(String id) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final campaign = _campaigns.firstWhere((c) => c.id == id);
    final newCampaign = campaign.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '${campaign.name} (Copy)',
      status: CampaignStatus.draft,
      actualSpend: 0.0,
      code: 'CMP-${DateTime.now().millisecond}',
    );
    _campaigns.add(newCampaign);
    return ApiResponse.success(newCampaign);
  }

  Future<ApiResponse<List<CampaignLead>>> getLeads(String campaignCode) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final leads = [
      CampaignLead(id: 'l1', campaignCode: campaignCode, name: 'John Doe', contact: '+966 50 123 4567', date: DateTime.now()),
      CampaignLead(id: 'l2', campaignCode: campaignCode, name: 'Fatima H.', contact: 'fatima@example.com', date: DateTime.now().subtract(const Duration(hours: 5))),
    ];
    return ApiResponse.success(leads);
  }
}
