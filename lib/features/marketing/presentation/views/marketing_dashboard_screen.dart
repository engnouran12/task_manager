import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/helper/dependencies.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/features/marketing/data/models/marketing_models.dart';
import 'package:task_manager/features/marketing/presentation/view_model/marketing_cubit.dart';
import 'package:task_manager/features/marketing/presentation/view_model/marketing_state.dart';
import 'package:task_manager/features/marketing/presentation/views/marketing_list_screen.dart';

class MarketingDashboardScreen extends StatelessWidget {
  const MarketingDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MarketingCubit>()..loadDashboard(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        appBar: AppBar(
          title: const Text('Marketing Dashboard'),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.list_alt),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MarketingListScreen()),
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<MarketingCubit, MarketingState>(
          builder: (context, state) {
            if (state is MarketingLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MarketingFailure) {
              return Center(child: Text(state.message));
            }

            if (state is MarketingDashboardLoaded) {
              return RefreshIndicator(
                onRefresh: () => context.read<MarketingCubit>().loadDashboard(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 20),
                      _buildStatusGrid(context, state.stats),
                      const SizedBox(height: 24),
                      if (state.pendingApprovals.isNotEmpty) ...[
                        _buildSectionTitle(context, 'Workflow Pending'),
                        const SizedBox(height: 12),
                        _buildApprovalList(context, state.pendingApprovals),
                        const SizedBox(height: 24),
                      ],
                      _buildSectionTitle(context, 'Budget Summary'),
                      const SizedBox(height: 12),
                      _buildBudgetSummary(context, state.topCampaigns),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: AppStyles.styleSemiBold20(context).copyWith(color: AppColors.darkPurple),
        ),
        Text(
          'Track your marketing performance',
          style: AppStyles.styleRegular12(context).copyWith(
            fontSize: responsiveComponantSize(context, 14),
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusGrid(BuildContext context, MarketingStats stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _buildStatusCard(context, 'Draft', stats.draftCount.toString(), Colors.grey, Icons.edit_note),
        _buildStatusCard(context, 'Pending', stats.pendingCount.toString(), Colors.orange, Icons.hourglass_empty),
        _buildStatusCard(context, 'Approved', stats.approvedCount.toString(), Colors.green, Icons.check_circle_outline),
        _buildStatusCard(context, 'Launched', stats.launchedCount.toString(), Colors.blue, Icons.rocket_launch_outlined),
      ],
    );
  }

  Widget _buildStatusCard(BuildContext context, String title, String count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title, 
                style: AppStyles.styleMedium14(context).copyWith(
                  fontSize: responsiveComponantSize(context, 16),
                  color: Colors.grey,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          Text(count, style: AppStyles.stylebold24(context).copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: AppStyles.styleSemiBold20(context).copyWith(
        fontSize: responsiveComponantSize(context, 18),
        color: AppColors.darkPurple,
      ),
    );
  }

  Widget _buildApprovalList(BuildContext context, List<WorkflowItem> items) {
    return Column(
      children: items.map((item) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.orange.withOpacity(0.2)),
        ),
        child: ListTile(
          leading: const CircleAvatar(backgroundColor: Color(0xFFFFF3E0), child: Icon(Icons.approval, color: Colors.orange)),
          title: Text(item.campaignName),
          subtitle: Text('Requested by ${item.requesterName}'),
          trailing: ElevatedButton(
            onPressed: () => context.read<MarketingCubit>().approveCampaign(item.campaignId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Approve'),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildBudgetSummary(BuildContext context, List<Campaign> campaigns) {
    return Column(
      children: campaigns.map((campaign) {
        final progress = campaign.totalBudget > 0 ? campaign.actualSpend / campaign.totalBudget : 0.0;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      campaign.name, 
                      style: AppStyles.styleMedium14(context).copyWith(
                        fontSize: responsiveComponantSize(context, 16),
                        color: AppColors.darkPurple,
                      ), 
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${campaign.actualSpend.toStringAsFixed(0)} / ${campaign.totalBudget.toStringAsFixed(0)} SAR',
                    style: AppStyles.styleSemiBold14(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[100],
                  valueColor: AlwaysStoppedAnimation<Color>(progress > 0.9 ? Colors.red : AppColors.deepPurple),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(progress * 100).toStringAsFixed(1)}% of budget used',
                style: AppStyles.styleRegular12(context).copyWith(color: Colors.grey),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
