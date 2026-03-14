import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/shared%20widget/custom_button.dart';
import 'package:task_manager/core/shared%20widget/custom_text_field.dart';
import 'package:task_manager/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:task_manager/features/auth/presentation/view_model/auth_state.dart';

class FormLogin extends StatelessWidget {
  FormLogin({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            var cubit = AuthCubit.get(context);
            return State is LogInLoadingState
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          customTextFormField(
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Email';
                              } else if (!RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            controller: cubit.emailController,
                            name: 'User Email',
                            hint: 'Entre Email ',
                            keyboardType: TextInputType.emailAddress,
                          ),
                           SizedBox(
                            height:responsiveComponantSize(context, 24),
                          ),
                          customTextFormField(
                            obscure: cubit.obsecure,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Password';
                              }
                              return null;
                            },
                            controller: cubit.passwordController,
                            name: 'Password',
                            hint: 'Entre password ',
                            keyboardType: TextInputType.text,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  cubit.changeobsecure();
                                },
                                icon: cubit.obsecure
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility)),
                          ),
                           SizedBox(
                            height: responsiveComponantSize(context, 16),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: cubit.isChecked,
                                onChanged: (bool? value) {
                                  cubit.changeCheckedStates(value);
                                },
                              ),
                              const Expanded(
                                child: FittedBox(
                                  child: Text(
                                    maxLines: 1,
                                    'By checking the box you agree to our Terms and Conditions',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                           SizedBox(
                            height:responsiveComponantSize(context, 298) ,
                          ),
                          customButton(
                            buttontext: 'login',
                            onpressed: ()async {
                              if (_formKey.currentState!.validate()&& cubit.isChecked==true) {
                               await  cubit.login(context);
                              }else if ( cubit.isChecked==false){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('You should agree to our terms and conditions ')),
                                );
                              }
                            }, context: context,
                          )
                        ],
                      ),
                    ),
                  );
          }
    );
  }
}
