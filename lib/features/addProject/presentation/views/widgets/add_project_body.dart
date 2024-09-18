import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/models/projects/project_model.dart';
import 'package:task_manager/core/shared%20widget/custom_button.dart';
import 'package:task_manager/core/shared%20widget/custom_text_field.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/addProject/presentation/view_model/add_project_cubit.dart';
import 'package:task_manager/features/addProject/presentation/view_model/add_project_state.dart';
import 'package:task_manager/features/addTask/presentation/views/widget/drop_down_item.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/employees/presentation/views/widget/employee_select_body.dart';
import 'package:task_manager/features/addProject/presentation/views/widgets/add_team_member_button.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/project_task_cubit.dart';

class AddProjectBody extends StatefulWidget {
  const AddProjectBody({super.key});

  @override
  _AddProjectBodyState createState() => _AddProjectBodyState();
}

class _AddProjectBodyState extends State<AddProjectBody> {
  List<EmployeeData> itemsemployee = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await getAllData(); // Asynchronously fetch data
  }

  Future<void> getAllData() async {
    var employeeCubit = context.read<EmployeesCubit>();
    var employees = await employeeCubit.getAllEmployees();

    setState(() {
      itemsemployee = employees;
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
        AddProjectCubit.get(context).nameController.clear();
        AddProjectCubit.get(context).descriptionController.clear();
        AddProjectCubit.get(context).dueDateController.clear();
        selectedEmployees.clear();
        AddProjectCubit.get(context).selectedprojectManager = '';
        return true;
      },
      child: BlocBuilder<AddProjectCubit, AddProjectState>(
        builder: (context, state) {
          var cubit = AddProjectCubit.get(context);
          return state is LoadingAddProjectState
              ? const Center(child: CircularProgressIndicator())
              : Scaffold(
                  body: Padding(
                    padding:
                        EdgeInsets.all(responsiveComponantSize(context, 24)),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: responsiveComponantSize(context, 16)),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.greyWhite),
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
                                      cubit.selectedprojectManager = '';
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      'Add Project',
                                      style: AppStyles.stylebold24(context)
                                          .copyWith(
                                              color: AppColors.darkPurple),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: responsiveComponantSize(context, 28)),
                            Text(
                              'Project Name',
                              style: AppStyles.styleMedium14(context),
                            ),
                            SizedBox(
                                height: responsiveComponantSize(context, 12)),
                            customTextFormField(
                              controller: cubit.nameController,
                              name: 'Enter Project Name',
                              keyboardType: TextInputType.text,
                              validation: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Project Name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                                height: responsiveComponantSize(context, 24)),
                            Text(
                              'Due Date',
                              style: AppStyles.styleMedium14(context),
                            ),
                            SizedBox(
                                height: responsiveComponantSize(context, 12)),
                            customTextFormField(
                              tapfunction: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030),
                                ).then((value) {
                                  cubit.dueDateController.text =
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
                              controller: cubit.dueDateController,
                              name: 'Enter Due Date & Time....',
                              keyboardType: TextInputType.datetime,
                            ),
                            SizedBox(
                                height: responsiveComponantSize(context, 24)),
                            Text(
                              'Priority',
                              style: AppStyles.styleMedium14(context)
                                  .copyWith(color: AppColors.black),
                            ),
                            SizedBox(
                                height: responsiveComponantSize(context, 12)),
                            SizedBox(
                              height: responsiveComponantSize(context, 45),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: cubit.priority.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      cubit.changePriority(index);
                                    },
                                    child: Container(
                                      width:
                                          responsiveComponantSize(context, 80),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: responsiveComponantSize(
                                              context, 8)),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: responsiveComponantSize(
                                              context, 4)),
                                      decoration: BoxDecoration(
                                        color: cubit.priority[index] ==
                                                cubit.selectedProjectPriority
                                            ? Colors.deepPurple.withOpacity(0.3)
                                            : Colors.deepPurple
                                                .withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          cubit.priority[index],
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
                            SizedBox(
                                height: responsiveComponantSize(context, 24)),
                            SizedBox(
                              height: responsiveComponantSize(context, 85),
                              child: DropDownButton<EmployeeData>(
                                hinttext: 'Choose project manager',
                                items: itemsemployee,
                                itemBuilder: (item) => Row(
                                  children: [
                                    Text(item.firstName),
                                    Text(item.secondName),
                                  ],
                                ),
                                onChanged: (selectedItem) {
                                  setState(() {
                                    cubit.selectedprojectManager =
                                        selectedItem?.id ?? '';
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                                height: responsiveComponantSize(context, 10)),
                            SizedBox(
                              height: responsiveComponantSize(context, 60),
                              child: AddTeamMemberOrProjectManagerButton(
                                text: 'Add Team Member',
                                onpressedScreen: () async {
                                  isView = false;
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddEmployeeToProject(),
                                    ),
                                  );
                                  _refreshEmployeeSelection();
                                },
                              ),
                            ),
                            SizedBox(
                                height: responsiveComponantSize(context, 24)),
                            Text(
                              'Description',
                              style: AppStyles.styleMedium14(context),
                            ),
                            SizedBox(
                                height: responsiveComponantSize(context, 12)),
                            customTextFormField(
                              controller: cubit.descriptionController,
                              name: 'Enter Description...',
                              keyboardType: TextInputType.text,
                              isDescription: true,
                            ),
                            SizedBox(
                                height: responsiveComponantSize(context, 12)),
                            customButton(
                              buttontext: 'Add Project',
                              onpressed: () {
                                if (selectedEmployees.isEmpty) {
                                  // Show an error message if manager or employees are not selected
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Please select a employees')),
                                  );
                                }else if (_formKey.currentState!.validate()) {
                                  ProjectModel project = ProjectModel(
                                    status: 'todo',
                                    name: cubit.nameController.text,
                                    dueDate: DateTime.parse(
                                        cubit.dueDateController.text),
                                    priority: selectedProjectPriority,
                                    description:
                                        cubit.descriptionController.text,
                                    employees: selectedEmployees,
                                    hidden: false,
                                    managerId: cubit.selectedprojectManager!,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                  );

                                  cubit.addProject(context, project);
                                  AddProjectCubit.get(context)
                                      .nameController
                                      .clear();
                                  AddProjectCubit.get(context)
                                      .descriptionController
                                      .clear();
                                  AddProjectCubit.get(context)
                                      .dueDateController
                                      .clear();
                                  selectedEmployees.clear();
                                  cubit.selectedprojectManager = '';
                                  context.read<ProjectTaskCubit>().getAllProjectTask();

                                }
                              },
                              context: context,
                            ),
                            SizedBox(
                                height: responsiveComponantSize(context, 40)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
