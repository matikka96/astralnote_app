import 'package:astralnote_app/global/blocks/auth/auth_cubit.dart';
import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notesCubit = BlocProvider.of<NotesCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Astralnotes')),
      body: Column(
        children: [
          // TextButton(
          //   onPressed: () async => authCubit.logout(),
          //   child: const Text('Logout'),
          // ),
          // TextButton(
          //   onPressed: () async => authCubit.login('matvei.tikka@outlook.com', 'Test123!'),
          //   child: const Text('Login'),
          // ),
          TextButton(
            onPressed: () async => notesCubit.loadNotes(),
            child: const Text('Load notes'),
          ),
          TextButton(
            onPressed: () => authCubit.deleteAccessToken(),
            child: const Text('Break access'),
          ),
          TextButton(
            onPressed: () => authCubit.printTokens(),
            child: const Text('Print tokens'),
          ),
          TextButton(
            onPressed: () => authCubit.logout(),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
