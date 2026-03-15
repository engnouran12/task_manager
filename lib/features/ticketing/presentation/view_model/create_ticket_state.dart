import 'package:equatable/equatable.dart';
import 'package:task_manager/features/ticketing/data/models/ticket_models.dart';

abstract class CreateTicketState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateTicketInitial extends CreateTicketState {}

class CreateTicketLoading extends CreateTicketState {}

class CreateTicketConfigLoaded extends CreateTicketState {
  final TicketConfig config;
  final Patient? selectedPatient;
  final bool isPatientLoading;
  final List<String> attachments;
  final String? successMessage;
  final String? errorMessage;

  CreateTicketConfigLoaded({
    required this.config,
    this.selectedPatient,
    this.isPatientLoading = false,
    this.attachments = const [],
    this.successMessage,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    config, 
    selectedPatient, 
    isPatientLoading, 
    attachments, 
    successMessage, 
    errorMessage
  ];

  CreateTicketConfigLoaded copyWith({
    TicketConfig? config,
    Patient? selectedPatient,
    bool? isPatientLoading,
    List<String>? attachments,
    String? successMessage,
    String? errorMessage,
  }) {
    return CreateTicketConfigLoaded(
      config: config ?? this.config,
      selectedPatient: selectedPatient ?? this.selectedPatient,
      isPatientLoading: isPatientLoading ?? this.isPatientLoading,
      attachments: attachments ?? this.attachments,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}

class CreateTicketFailure extends CreateTicketState {
  final String message;
  CreateTicketFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateTicketSuccess extends CreateTicketState {
  final String message;
  CreateTicketSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
