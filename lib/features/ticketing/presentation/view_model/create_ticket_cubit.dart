import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/ticketing/data/models/ticket_models.dart';
import 'package:task_manager/features/ticketing/data/services/mock_ticket_service.dart';
import 'package:task_manager/features/ticketing/presentation/view_model/create_ticket_state.dart';

class CreateTicketCubit extends Cubit<CreateTicketState> {
  final MockTicketService _ticketService;

  CreateTicketCubit(this._ticketService) : super(CreateTicketInitial());

  Future<void> fetchConfig() async {
    emit(CreateTicketLoading());
    final response = await _ticketService.getConfig();
    if (response.success && response.data != null) {
      emit(CreateTicketConfigLoaded(config: response.data!));
    } else {
      emit(CreateTicketFailure(response.message));
    }
  }

  Future<void> lookupPatient(String fileNumber) async {
    if (state is CreateTicketConfigLoaded) {
      final s = state as CreateTicketConfigLoaded;
      emit(s.copyWith(isPatientLoading: true));
      
      final response = await _ticketService.lookupPatient(fileNumber);
      if (response.success) {
        emit(s.copyWith(selectedPatient: response.data, isPatientLoading: false));
      } else {
        emit(s.copyWith(errorMessage: response.message, isPatientLoading: false));
      }
    }
  }

  void addAttachment() {
    if (state is CreateTicketConfigLoaded) {
      final s = state as CreateTicketConfigLoaded;
      final newAttachments = List<String>.from(s.attachments)..add('assets/mock_image_${s.attachments.length + 1}.jpg');
      emit(s.copyWith(attachments: newAttachments));
    }
  }

  Future<void> submitTicket({
    required String subject,
    required String description,
    required String source,
    required String type,
    required String classification,
    required String priority,
  }) async {
    if (state is CreateTicketConfigLoaded) {
      final s = state as CreateTicketConfigLoaded;
      if (s.selectedPatient == null) {
        emit(s.copyWith(errorMessage: 'Please lookup a patient first'));
        return;
      }

      emit(CreateTicketLoading());
      
      final ticket = Ticket(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        ticketNumber: 'TKT-PENDING',
        subject: subject,
        description: description,
        status: 'Open',
        priority: priority,
        source: source,
        type: type,
        classification: classification,
        patient: s.selectedPatient!,
        createdAt: DateTime.now(),
        slaDueDate: DateTime.now().add(const Duration(hours: 24)),
      );

      final response = await _ticketService.createTicket(ticket);
      if (response.success) {
        emit(CreateTicketSuccess(response.message));
      } else {
        emit(CreateTicketFailure(response.message));
      }
    }
  }

  void clearError() {
    if (state is CreateTicketConfigLoaded) {
      final s = state as CreateTicketConfigLoaded;
      emit(s.copyWith(errorMessage: null));
    }
  }
}
