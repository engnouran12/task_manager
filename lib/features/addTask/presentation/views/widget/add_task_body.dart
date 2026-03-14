import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/models/projects/project_model.dart';
import 'package:task_manager/core/models/task/task_model.dart';
import 'package:task_manager/core/shared%20widget/custom_button.dart';
import 'package:task_manager/core/shared%20widget/custom_text_field.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/addProject/presentation/view_model/add_project_cubit.dart';
import 'package:task_manager/features/addTask/presentation/view_model/add_task_cubit.dart';
import 'package:task_manager/features/addTask/presentation/view_model/add_task_state.dart';
import 'package:task_manager/features/addTask/presentation/views/widget/drop_down_item.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/project_task_cubit.dart';

class AddTaskBody extends StatefulWidget {
  const AddTaskBody({super.key});

  @override
  State<AddTaskBody> createState() => _AddTaskBodyState();
}

class _AddTaskBodyState extends State<AddTaskBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late ProjectModel originalProject;

  List<ProjectModel> itemsproject = [];
  List<EmployeeData> itemsemployee = [];

  String? selectedProjectid = '';
  String? selectedEmployeetid = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await getAllData();
    setState(() {}); // Ensure UI is updated after fetching data
  }

  Future<void> getAllData() async {
    try {
      var projectCubit = AddProjectCubit.get(context);
      var employeeCubit = context.read<EmployeesCubit>();
      itemsproject = await projectCubit.getAllProjects();
      itemsemployee = await employeeCubit.getAllEmployees();
    } catch (e) {
      // Handle errors if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dueDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTaskCubit, AddTaskState>(
      listener: (context, state) {},
      builder: (context, state) {
        var addTaskCubit = AddTaskCubit.get(context);

        return Scaffold(
            body: Padding(
          padding: EdgeInsets.all(responsiveComponantSize(context, 24)),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: responsiveComponantSize(context, 15)),
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Add Tasks',
                            style: AppStyles.stylebold24(context)
                                .copyWith(color: AppColors.darkPurple),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsiveComponantSize(context, 25)),
                  Text('Task Name', style: AppStyles.styleMedium14(context)),
                  SizedBox(height: responsiveComponantSize(context, 12)),
                  customTextFormField(
                    controller: _nameController,
                    name: 'Enter Task Name',
                    keyboardType: TextInputType.text,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter task Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: responsiveComponantSize(context, 24)),
                  Text('Due Date', style: AppStyles.styleMedium14(context)),
                  SizedBox(height: responsiveComponantSize(context, 12)),
                  customTextFormField(
                    tapfunction: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      ).then((value) {
                        _dueDateController.text =
                            value!.toString().substring(0, 10);
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
                    name: 'Enter Due Date & Time...',
                    keyboardType: TextInputType.datetime,
                  ),
                  SizedBox(height: responsiveComponantSize(context, 24)),
                  Text('Priority',
                      style: AppStyles.styleMedium14(context)
                          .copyWith(color: AppColors.black)),
                  SizedBox(height: responsiveComponantSize(context, 12)),
                  SizedBox(
                    height: responsiveComponantSize(context, 60),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: addTaskCubit.priority.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            addTaskCubit.changePriority(index);
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
                              color: addTaskCubit.priority[index] ==
                                      addTaskCubit.selectedTaskPriority
                                  ? Colors.deepPurple.withOpacity(0.3)
                                  : Colors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                addTaskCubit.priority[index],
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
                    height: responsiveComponantSize(context, 80),
                    child: DropDownButton<ProjectModel>(
                      hinttext: 'Choose Project',
                      items: itemsproject,
                      itemBuilder: (item) => Text(item.name),
                      onChanged: (selectedItem) {
                        setState(() {
                          selectedProjectid = selectedItem?.id ?? '';
                        });
                      },
                    ),
                  ),
                  SizedBox(height: responsiveComponantSize(context, 10)),
                  SizedBox(
                    height: responsiveComponantSize(context, 80),
                    child: DropDownButton<EmployeeData>(
                      hinttext: 'Choose Employee',
                      items: itemsemployee,
                      itemBuilder: (item) => Row(
                        children: [
                          Text(item.firstName),
                          Text(item.secondName),
                        ],
                      ),
                      onChanged: (selectedItem) {
                        setState(() {
                          selectedEmployeetid = selectedItem?.id ?? '';
                        });
                      },
                    ),
                  ),
                  SizedBox(height: responsiveComponantSize(context, 10)),
                  Text('Description', style: AppStyles.styleMedium14(context)),
                  customTextFormField(
                    controller: _descriptionController,
                    name: 'Enter Description...',
                    keyboardType: TextInputType.text,
                    isDescription: true,
                  ),
                  SizedBox(height: responsiveComponantSize(context, 50)),
                  customButton(
                    context: context,
                    buttontext: 'Add Task',
                    onpressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var taskModel = TaskModel(
                          done: false,
                          projectId: selectedProjectid!,
                          priority: addTaskCubit.selectedTaskPriority,
                          date: DateTime.parse(_dueDateController.text),
                          description: _descriptionController.text,
                          name: _nameController.text,
                          employeeId: selectedEmployeetid!,
                          createdat: DateTime.now(),
                          updatedat: DateTime.now(),
                        );

                        try {
                          // Add the task
                          await addTaskCubit.addTask(taskModel, token!);

                          // Fetch the original project (awaiting the Future)
                          originalProject = await AddProjectCubit.get(context).findProjectById(selectedProjectid!);

                          // Update the project status
                          final updatedProject = originalProject.copyWith(status: 'inprogress');

                          // Update the project in the ProjectTaskCubit
                          await ProjectTaskCubit.get(context).editProject(selectedProjectid!, updatedProject, context);

                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Task added successfully')),
                          );

                          // Clear the form fields
                          _nameController.clear();
                          _dueDateController.clear();
                          _descriptionController.clear();
                          selectedProjectid = '';
                          selectedEmployeetid = '';
                          itemsemployee = [];
                          itemsproject = [];
                        } catch (e) {
                          // Handle any errors
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to add task')),
                          );
                        }
                      }


                    },
                  ),
                  SizedBox(height: responsiveComponantSize(context, 45)),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}
