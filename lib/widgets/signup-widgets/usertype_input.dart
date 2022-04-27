import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/signup-cubit/signup_cubit.dart';

class UserTypeInput extends StatefulWidget {
  const UserTypeInput({Key? key}) : super(key: key);

  @override
  State<UserTypeInput> createState() => _UserTypeInputState();
}

class _UserTypeInputState extends State<UserTypeInput> {
  final List<String> _userTypes = ['Elderly', 'Dependant', 'Caregivers'];
  var _selectedUserType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return DropdownButtonFormField<String>(
          validator: (value) => value == null ? 'Field required' : null,
          isExpanded: true,
          hint: const Text("Please Choose A User Type"),
          value: _selectedUserType,
          items: _userTypes.map((String userType) {
            return DropdownMenuItem<String>(
              child: Text(userType),
              value: userType,
            );
          }).toList(),
          onChanged: (userType) {
            setState(() {
              _selectedUserType = userType;
              context
                  .read<SignupCubit>()
                  .userTypeChanged(_selectedUserType.toString());
            });
          },
        );
      },
    );
  }
}
