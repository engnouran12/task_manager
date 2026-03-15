import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/helper/dependencies.dart';
import 'package:task_manager/features/ticketing/data/models/ticket_models.dart';
import 'package:task_manager/features/ticketing/presentation/view_model/create_ticket_cubit.dart';
import 'package:task_manager/features/ticketing/presentation/view_model/create_ticket_state.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _fileNumberController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? _selectedSource;
  String? _selectedType;
  String? _selectedPriority;
  TicketTemplate? _selectedTemplate;

  @override
  void dispose() {
    _fileNumberController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateTicketCubit>()..fetchConfig(),
      child: BlocListener<CreateTicketCubit, CreateTicketState>(
        listener: (context, state) {
          if (state is CreateTicketSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pop(context);
          } else if (state is CreateTicketFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is CreateTicketConfigLoaded && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            context.read<CreateTicketCubit>().clearError();
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('New Ticket')),
          body: BlocBuilder<CreateTicketCubit, CreateTicketState>(
            builder: (context, state) {
              if (state is CreateTicketLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is CreateTicketConfigLoaded) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Patient Information'),
                      _buildPatientLookup(context, state),
                      if (state.selectedPatient != null)
                        _buildPatientCard(state.selectedPatient!),
                      
                      const SizedBox(height: 24),
                      _buildSectionTitle('Ticket Details'),
                      _buildTemplateDropdown(context, state),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _subjectController,
                        label: 'Subject',
                        hint: 'Brief summary of the issue',
                      ),
                      const SizedBox(height: 12),
                      _buildDescriptionField(context),
                      
                      const SizedBox(height: 24),
                      _buildSectionTitle('Classification'),
                      _buildSourceDropdown(context, state),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildTypeDropdown(context, state)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildPriorityDropdown(context, state)),
                        ],
                      ),

                      const SizedBox(height: 24),
                      _buildSectionTitle('Attachments'),
                      _buildAttachmentsSection(context, state),

                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.read<CreateTicketCubit>().submitTicket(
                            subject: _subjectController.text,
                            description: _descriptionController.text,
                            source: _selectedSource ?? state.config.sources.first,
                            type: _selectedType ?? state.config.types.first,
                            classification: state.config.classifications.first,
                            priority: _selectedPriority ?? state.config.priorities.first,
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Submit Ticket', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPatientLookup(BuildContext context, CreateTicketConfigLoaded state) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _fileNumberController,
            decoration: InputDecoration(
              labelText: 'File Number',
              hintText: 'Enter patient file number',
              prefixIcon: const Icon(Icons.badge_outlined),
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner, color: Colors.blue),
                onPressed: () {
                   _fileNumberController.text = 'F12345';
                   context.read<CreateTicketCubit>().lookupPatient('F12345');
                },
              ),
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (val) => context.read<CreateTicketCubit>().lookupPatient(val),
          ),
        ),
        const SizedBox(width: 8),
        if (state.isPatientLoading)
          const CircularProgressIndicator()
        else
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.read<CreateTicketCubit>().lookupPatient(_fileNumberController.text),
          ),
      ],
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        color: Colors.blue.withOpacity(0.05),
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(patient.name),
          subtitle: Text('ID: ${patient.fileNumber}'),
        ),
      ),
    );
  }

  Widget _buildTemplateDropdown(BuildContext context, CreateTicketConfigLoaded state) {
    return DropdownButtonFormField<TicketTemplate>(
      value: _selectedTemplate,
      decoration: const InputDecoration(
        labelText: 'Use Template',
        prefixIcon: Icon(Icons.copy_all),
        border: OutlineInputBorder(),
      ),
      items: state.config.templates.map((t) {
        return DropdownMenuItem(value: t, child: Text(t.name));
      }).toList(),
      onChanged: (template) {
        if (template != null) {
          setState(() {
            _selectedTemplate = template;
            _subjectController.text = template.subject;
            _descriptionController.text = template.description;
            _selectedType = template.type;
            _selectedPriority = template.priority;
          });
        }
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return TextField(
      controller: _descriptionController,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: 'Description',
        hintText: 'Detailed description of the complaint...',
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
        suffixIcon: IconButton(
          icon: const Icon(Icons.mic, color: Colors.red),
          onPressed: () {
            setState(() {
              _descriptionController.text += ' This is a mock voice-to-text dictation.';
            });
          },
        ),
      ),
    );
  }

  Widget _buildSourceDropdown(BuildContext context, CreateTicketConfigLoaded state) {
    return DropdownButtonFormField<String>(
      value: _selectedSource ?? state.config.sources.first,
      decoration: const InputDecoration(labelText: 'Ticket Source', border: OutlineInputBorder()),
      items: state.config.sources.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
      onChanged: (val) => setState(() => _selectedSource = val),
    );
  }

  Widget _buildTypeDropdown(BuildContext context, CreateTicketConfigLoaded state) {
    return DropdownButtonFormField<String>(
      value: _selectedType ?? state.config.types.first,
      decoration: const InputDecoration(labelText: 'Ticket Type', border: OutlineInputBorder()),
      items: state.config.types.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
      onChanged: (val) => setState(() => _selectedType = val),
    );
  }

  Widget _buildPriorityDropdown(BuildContext context, CreateTicketConfigLoaded state) {
    return DropdownButtonFormField<String>(
      value: _selectedPriority ?? state.config.priorities.first,
      decoration: const InputDecoration(labelText: 'Priority', border: OutlineInputBorder()),
      items: state.config.priorities.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
      onChanged: (val) => setState(() => _selectedPriority = val),
    );
  }

  Widget _buildAttachmentsSection(BuildContext context, CreateTicketConfigLoaded state) {
    return Column(
      children: [
        Row(
          children: [
            _buildAttachmentButton(Icons.camera_alt, 'Camera', () => context.read<CreateTicketCubit>().addAttachment()),
            const SizedBox(width: 12),
            _buildAttachmentButton(Icons.photo_library, 'Gallery', () => context.read<CreateTicketCubit>().addAttachment()),
          ],
        ),
        if (state.attachments.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.attachments.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(top: 8, right: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(child: Icon(Icons.image, color: Colors.grey)),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAttachmentButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
      ),
    );
  }
}
