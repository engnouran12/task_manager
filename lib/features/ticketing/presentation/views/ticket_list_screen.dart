import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/helper/dependencies.dart';
import 'package:task_manager/features/ticketing/presentation/view_model/ticket_cubit.dart';
import 'package:task_manager/features/ticketing/presentation/view_model/ticket_state.dart';
import 'package:task_manager/features/ticketing/presentation/widgets/ticket_card.dart';
import 'package:task_manager/features/ticketing/presentation/views/create_ticket_screen.dart';

class TicketListScreen extends StatelessWidget {
  const TicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TicketCubit>()..fetchTickets(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tickets'),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<TicketCubit>().fetchTickets(),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const _SearchBar(),
            const _FilterBar(),
            Expanded(
              child: BlocBuilder<TicketCubit, TicketState>(
                builder: (context, state) {
                  if (state is TicketLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is TicketFailure) {
                    return Center(child: Text(state.message));
                  }

                  if (state is TicketSuccess) {
                    if (state.tickets.isEmpty) {
                      return const Center(child: Text('No tickets found'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.tickets.length,
                      itemBuilder: (context, index) {
                        return TicketCard(
                          ticket: state.tickets[index],
                          onTap: () {
                            // Detail view would go here
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTicketScreen()),
          ),
          label: const Text('Create Ticket'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (query) => context.read<TicketCubit>().updateSearch(query),
        decoration: InputDecoration(
          hintText: 'Search by number, subject, or patient...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).primaryColor.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketCubit, TicketState>(
      builder: (context, state) {
        String selectedStatus = 'All';
        String selectedPriority = 'All';

        if (state is TicketSuccess) {
          selectedStatus = state.selectedStatus;
          selectedPriority = state.selectedPriority;
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _FilterChip(
                label: 'Status',
                options: const ['All', 'Open', 'In Progress', 'Pending', 'Closed'],
                selected: selectedStatus,
                onSelected: (val) => context.read<TicketCubit>().updateStatusFilter(val ?? 'All'),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Priority',
                options: const ['All', 'Low', 'Medium', 'High', 'Critical'],
                selected: selectedPriority,
                onSelected: (val) => context.read<TicketCubit>().updatePriorityFilter(val ?? 'All'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final List<String> options;
  final String selected;
  final Function(String?) onSelected;

  const _FilterChip({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected != 'All';
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (context) => options
          .map((opt) => PopupMenuItem(
                value: opt,
                child: Text(opt),
              ))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : Colors.white,
          border: Border.all(color: theme.primaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              '$label: $selected',
              style: TextStyle(
                color: isSelected ? Colors.white : theme.primaryColor,
                fontSize: 12,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: isSelected ? Colors.white : theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
