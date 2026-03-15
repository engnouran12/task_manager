import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/mock/mock_data.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/models/projects/project_model.dart';
import 'package:task_manager/core/shared%20widget/custom_button.dart';
import 'package:task_manager/core/shared%20widget/custom_text_field.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/addTask/presentation/views/widget/drop_down_item.dart';
import 'package:task_manager/features/employees/presentation/views/widget/employee_select_body.dart';
import 'package:task_manager/features/addProject/presentation/views/widgets/add_team_member_button.dart';

class AddProjectBody extends StatefulWidget {
  const AddProjectBody({super.key});

  @override
  _AddProjectBodyState createState() => _AddProjectBodyState();
}

class _AddProjectBodyState extends State<AddProjectBody> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedProjectPriority = 'low';
  String? _selectedprojectManager = '';
  
  final List<String> priority = [
    'high',
    'medium',
    'low',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _dueDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void changePriority(int index) {
    setState(() {
      _selectedProjectPriority = priority[index];
    });
  }

  void _refreshEmployeeSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Clear selectedEmployees when navigating back
        _nameController.clear();
        _descriptionController.clear();
        _dueDateController.clear();
        selectedEmployees.clear();
        _selectedprojectManager = '';
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(responsiveComponantSize(context, 24)),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: responsiveComponantSize(context, 16)),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.greyWhite),
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.darkPurple,
                          ),
                          onPressed: () {
                            selectedEmployees.clear();
                            _selectedprojectManager = '';
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Add Project',
                            style: AppStyles.stylebold24(context)
                                .copyWith(color: AppColors.darkPurple),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsiveComponantSize(context, 28)),
                  Text(
                    'Project Name',
                    style: AppStyles.styleMedium14(context),
                  ),
                  SizedBox(height: responsiveComponantSize(context, 12)),
                  customTextFormField(
                    controller: _nameController,
                    name: 'Enter Project Name',
                    keyboardType: TextInputType.text,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Project Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: responsiveComponantSize(context, 24)),
                  Text(
                    'Due Date',
                    style: AppStyles.styleMedium14(context),
                  ),
                  SizedBox(height: responsiveComponantSize(context, 12)),
                  customTextFormField(
                    tapfunction: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      ).then((value) {
                        if (value != null) {
                          _dueDateController.text =
                              value.toString().substring(0, 10);
                        }
                      });
                      return null;
                    },
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter due data';
                      }
                      return null;
                    },
                    controller: _dueDateController,
                    name: 'Enter Due Date & Time....',
                    keyboardType: TextInputType.datetime,
                  ),
                  SizedBox(height: responsiveComponantSize(context, 24)),
                  Text(
                    'Priority',
                    style: AppStyles.styleMedium14(context)
                        .copyWith(color: AppColors.black),
                  ),
                  SizedBox(height: responsiveComponantSize(context, 12)),
                  SizedBox(
                    height: responsiveComponantSize(context, 45),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: priority.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            changePriority(index);
                          },
                          child: Container(
                            width: responsiveComponantSize(context, 80),
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    responsiveComponantSize(context, 8)),
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    responsiveComponantSize(context, 4)),
                            decoration: BoxDecoration(
                              color: priority[index] == _selectedProjectPriority
                                  ? Colors.deepPurple.withOpacity(0.3)
                                  : Colors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                priority[index],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: responsiveComponantSize(context, 24)),
                  SizedBox(
                    height: responsiveComponantSize(context, 85),
                    child: DropDownButton<EmployeeData>(
                      hinttext: 'Choose project manager',
                      items: MockData.employeeDataList, // Used mock data
                      itemBuilder: (item) => Row(
                        children: [
                          Text('${item.firstName} '),
                          Text(item.secondName),
                        ],
                      ),
                      onChanged: (selectedItem) {
                        setState(() {
                          _selectedprojectManager = selectedItem?.id ?? '';
                        });
                      },
                    ),
                  ),
                  SizedBox(height: responsiveComponantSize(context, 10)),
                  SizedBox(
                    height: responsiveComponantSize(context, 60),
                    child: AddTeamMemberOrProjectManagerButton(
                      text: 'Add Team Member',
                      onpressedScreen: () async {
                        isView = false;
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddEmployeeToProject(),
                          ),
                        );
                        _refreshEmployeeSelection();
                      },
                    ),
                  ),
                  SizedBox(height: responsiveComponantSize(context, 24)),
                  Text(
                    'Description',
                    style: AppStyles.styleMedium14(context),
                  ),
                  SizedBox(height: responsiveComponantSize(context, 12)),
                  customTextFormField(
                    controller: _descriptionController,
                    name: 'Enter Description...',
                    keyboardType: TextInputType.text,
                    isDescription: true,
                  ),
                  SizedBox(height: responsiveComponantSize(context, 12)),
                  customButton(
                    buttontext: 'Add Project',
                    onpressed: () {
                      if (selectedEmployees.isEmpty ||
                          _selectedprojectManager == null ||
                          _selectedprojectManager!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please select a manager and employees')),
                        );
                      } else if (_formKey.currentState!.validate()) {
                        ProjectModel project = ProjectModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(), // Mock an arbitrary ID
                          status: 'todo',
                          name: _nameController.text,
                          dueDate: DateTime.parse(_dueDateController.text),
                          priority: _selectedProjectPriority,
                          description: _descriptionController.text,
                          employees: List.from(selectedEmployees),
                          hidden: false,
                          managerId: _selectedprojectManager!,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        );

                        // Emulate submitting the form to BLaC logic
                        MockData.projects.add(project);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Project Added Successfully')),
                        );

                        _nameController.clear();
                        _descriptionController.clear();
                        _dueDateController.clear();
                        selectedEmployees.clear();
                        _selectedprojectManager = '';

                        Navigator.pop(context);
                      }
                    },
                    context: context,
                  ),
                  SizedBox(height: responsiveComponantSize(context, 40)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
