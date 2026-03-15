import 'package:equatable/equatable.dart';
import 'package:task_manager/features/ticketing/data/models/ticket_models.dart';

abstract class TicketState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class TicketSuccess extends TicketState {
  final List<Ticket> tickets;
  final String searchQuery;
  final String selectedStatus;
  final String selectedPriority;

  TicketSuccess({
    required this.tickets,
    this.searchQuery = '',
    this.selectedStatus = 'All',
    this.selectedPriority = 'All',
  });

  @override
  List<Object?> get props => [tickets, searchQuery, selectedStatus, selectedPriority];

  TicketSuccess copyWith({
    List<Ticket>? tickets,
    String? searchQuery,
    String? selectedStatus,
    String? selectedPriority,
  }) {
    return TicketSuccess(
      tickets: tickets ?? this.tickets,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedPriority: selectedPriority ?? this.selectedPriority,
    );
  }
}

class TicketFailure extends TicketState {
  final String message;
  TicketFailure(this.message);

  @override
  List<Object?> get props => [message];
}
