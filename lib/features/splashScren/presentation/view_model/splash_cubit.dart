import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/splashScren/presentation/view_model/splash_state.dart';

class SplashCubit extends Cubit<SplashState>{
  SplashCubit() : super(SplashIntialState());
  static SplashCubit get(context) => BlocProvider.of(context);

}