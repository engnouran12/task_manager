import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/ticketing/data/models/ticket_models.dart';
import 'package:task_manager/features/ticketing/data/services/mock_ticket_service.dart';
import 'package:task_manager/features/ticketing/presentation/view_model/ticket_state.dart';

class TicketCubit extends Cubit<TicketState> {
  final MockTicketService _ticketService;
  List<Ticket> _allTickets = [];
  Timer? _debounce;

  TicketCubit(this._ticketService) : super(TicketInitial());

  Future<void> fetchTickets() async {
    emit(TicketLoading());
    final response = await _ticketService.getTickets();
    if (response.success && response.data != null) {
      _allTickets = response.data!;
      _applyFilters();
    } else {
      emit(TicketFailure(response.message));
    }
  }

  void updateSearch(String query) {
    if (state is TicketSuccess) {
      final successState = state as TicketSuccess;
      emit(successState.copyWith(searchQuery: query));
      
      // Debounce search logic
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        _allTickets = _allTickets; // Ensure we use the latest list if it changed
        _applyFilters();
      });
    }
  }

  void updateStatusFilter(String status) {
    if (state is TicketSuccess) {
      final successState = state as TicketSuccess;
      emit(successState.copyWith(selectedStatus: status));
      _applyFilters();
    }
  }

  void updatePriorityFilter(String priority) {
    if (state is TicketSuccess) {
      final successState = state as TicketSuccess;
      emit(successState.copyWith(selectedPriority: priority));
      _applyFilters();
    }
  }

  void _applyFilters() {
    String query = '';
    String status = 'All';
    String priority = 'All';

    if (state is TicketSuccess) {
      final s = state as TicketSuccess;
      query = s.searchQuery;
      status = s.selectedStatus;
      priority = s.selectedPriority;
    }

    var result = _allTickets.toList();

    if (query.isNotEmpty) {
      result = result.where((t) =>
        t.subject.toLowerCase().contains(query.toLowerCase()) ||
        t.ticketNumber.toLowerCase().contains(query.toLowerCase()) ||
        t.patient.name.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }

    if (status != 'All') {
      result = result.where((t) => t.status == status).toList();
    }

    if (priority != 'All') {
      result = result.where((t) => t.priority == priority).toList();
    }

    // Default Sorting: Priority + SLA due time
    result.sort((a, b) {
      final priorityWeight = {
        'Critical': 0,
        'High': 1,
        'Medium': 2,
        'Low': 3,
      };
      
      int cmp = (priorityWeight[a.priority] ?? 4).compareTo(priorityWeight[b.priority] ?? 4);
      if (cmp != 0) return cmp;
      return a.slaDueDate.compareTo(b.slaDueDate);
    });

    emit(TicketSuccess(
      tickets: result,
      searchQuery: query,
      selectedStatus: status,
      selectedPriority: priority,
    ));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
