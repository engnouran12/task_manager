import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/home/presentation/view_model/home_state.dart';

class HomeCubit extends Cubit<HomeState>{
  HomeCubit() : super(HomeIntialState());
  static HomeCubit get(context) => BlocProvider.of(context);

}