import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_theme.dart';
import 'package:nabd/core/utils/navigation_service.dart'; // ← أضف ده
import 'package:nabd/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:nabd/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nabd/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nabd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nabd/features/appointments/data/datasources/appointments_remote_datasource.dart';
import 'package:nabd/features/appointments/data/repositories/appointments_repository_impl.dart';
import 'package:nabd/features/appointments/presentation/bloc/book_appointment_bloc.dart';
import 'package:nabd/features/appointments/presentation/bloc/my_appointments_bloc.dart';
import 'package:nabd/features/home/data/datasources/home_remote_datasource.dart';
import 'package:nabd/features/home/data/repositories/home_repository_impl.dart';
import 'package:nabd/features/home/presentation/bloc/home_bloc.dart';
import 'package:nabd/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:nabd/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:nabd/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:nabd/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nabd/features/splash/presentation/pages/splash_screen.dart';
import 'package:nabd/features/ai_chat/data/datasources/ai_chat_remote_datasource.dart';
import 'package:nabd/features/ai_chat/data/repositories/ai_chat_repository_impl.dart';
import 'package:nabd/features/ai_chat/presentation/bloc/ai_chat_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentsRepository = AppointmentsRepositoryImpl(
      remoteDatasource: AppointmentsRemoteDatasource(),
    );

    final profileRepository = ProfileRepositoryImpl(
      remoteDatasource: ProfileRemoteDatasource(),
      localDatasource: ProfileLocalDatasource(),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            authRepository: AuthRepositoryImpl(
              remoteDatasource: AuthRemoteDatasource(),
              localDatasource: AuthLocalDatasource(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => BookAppointmentBloc(
            repository: appointmentsRepository,
            profileRepository: profileRepository,
          ),
        ),
        BlocProvider(
          create: (_) => MyAppointmentsBloc(repository: appointmentsRepository),
        ),
        BlocProvider(
          create: (_) => ProfileBloc(profileRepository: profileRepository),
        ),
        BlocProvider(
          create: (_) => HomeBloc(
            homeRepository: HomeRepositoryImpl(
              remoteDatasource: HomeRemoteDatasource(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => AiChatBloc(
            repository: AiChatRepositoryImpl(
              remoteDatasource: AiChatRemoteDatasource(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey, // ← أضف ده
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
