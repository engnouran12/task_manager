import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/projectDetails/presentation/view_model/project_details_state.dart';

class ProjectDetailsCubit extends Cubit<ProjectDetailsState>{
  ProjectDetailsCubit() : super(ProjectDetailsIntialState());
  static ProjectDetailsCubit get(context) => BlocProvider.of(context);

}