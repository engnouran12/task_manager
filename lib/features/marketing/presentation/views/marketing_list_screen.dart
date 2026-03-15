import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/helper/dependencies.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/features/marketing/data/models/marketing_models.dart';
import 'package:task_manager/features/marketing/presentation/view_model/marketing_cubit.dart';
import 'package:task_manager/features/marketing/presentation/view_model/marketing_state.dart';

class MarketingListScreen extends StatelessWidget {
  const MarketingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MarketingCubit>()..loadCampaigns(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Campaigns')),
        body: BlocBuilder<MarketingCubit, MarketingState>(
          builder: (context, state) {
            if (state is MarketingLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MarketingFailure) {
              return Center(child: Text(state.message));
            }

            if (state is MarketingListLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.campaigns.length,
                itemBuilder: (context, index) {
                  return _CampaignCard(campaign: state.campaigns[index]);
                },
              );
            }
            
            if (state is MarketingLeadsLoaded) {
              return _LeadsView(leads: state.leads, campaignCode: state.campaignCode);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final Campaign campaign;
  const _CampaignCard({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Dismissible(
          key: Key(campaign.id),
          direction: campaign.status == CampaignStatus.draft ? DismissDirection.startToEnd : DismissDirection.none,
          background: Container(
            color: Colors.green,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(Icons.send, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              context.read<MarketingCubit>().submitCampaign(campaign.id);
              return false;
            }
            return false;
          },
          child: ExpansionTile(
            title: Text(
              campaign.name, 
              style: AppStyles.styleSemiBold14(context).copyWith(
                fontSize: responsiveComponantSize(context, 16),
              ),
            ),
            subtitle: Text(campaign.code, style: const TextStyle(color: Colors.grey)),
            leading: _StatusIcon(status: campaign.status),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ActionButton(
                          icon: Icons.people_outline,
                          label: 'Leads',
                          onTap: () => context.read<MarketingCubit>().viewLeads(campaign.code),
                        ),
                        _ActionButton(
                          icon: Icons.copy,
                          label: 'Duplicate',
                          onTap: () => context.read<MarketingCubit>().duplicateCampaign(campaign.id),
                        ),
                        if (campaign.status == CampaignStatus.draft)
                          _ActionButton(
                            icon: Icons.send,
                            label: 'Submit',
                            onTap: () => context.read<MarketingCubit>().submitCampaign(campaign.id),
                          ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final CampaignStatus status;
  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    switch (status) {
      case CampaignStatus.draft:
        color = Colors.grey;
        icon = Icons.edit_note;
      case CampaignStatus.pending:
        color = Colors.orange;
        icon = Icons.hourglass_empty;
      case CampaignStatus.approved:
        color = Colors.green;
        icon = Icons.check_circle_outline;
      case CampaignStatus.launched:
        color = Colors.blue;
        icon = Icons.rocket_launch;
    }
    return CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 20));
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: AppColors.deepPurple),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _LeadsView extends StatelessWidget {
  final List<CampaignLead> leads;
  final String campaignCode;

  const _LeadsView({required this.leads, required this.campaignCode});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.read<MarketingCubit>().loadCampaigns(),
              ),
              Text(
                'Leads for $campaignCode', 
                style: AppStyles.styleSemiBold20(context).copyWith(
                  fontSize: responsiveComponantSize(context, 18),
                  color: AppColors.darkPurple,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: leads.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final lead = leads[index];
              return ListTile(
                title: Text(lead.name),
                subtitle: Text(lead.contact),
                trailing: Text(lead.date.toIso8601String().substring(0, 10)),
              );
            },
          ),
        ),
      ],
    );
  }
}
