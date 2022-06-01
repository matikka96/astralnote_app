import 'package:astralnote_app/global/blocks/auth/auth_cubit.dart';
import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalBlocs extends StatelessWidget {
  const GlobalBlocs({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()..init()),
        BlocProvider<NotesCubit>(create: (_) => NotesCubit()..init()),
      ],
      child: child,
    );
  }
}
