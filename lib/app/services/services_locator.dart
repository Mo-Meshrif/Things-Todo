import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

import '/app/services/network_services.dart';
import '/app/utils/constants_manager.dart';
import '/modules/auth/domain/usecases/forget_passwod_use_case.dart';
import '/modules/auth/domain/usecases/google_use_case.dart';
import '/modules/auth/domain/usecases/login_use_case.dart';
import '/modules/auth/domain/usecases/sign_in_with_credential.dart';
import '/modules/auth/domain/usecases/signup_use_case.dart';
import '/modules/auth/domain/usecases/twitter_use_case.dart';
import '/modules/auth/presentation/controller/auth_bloc.dart';
import '../../modules/auth/data/datasources/remote_data_source.dart';
import '../../modules/auth/data/repositories/auth_repository_impl.dart';
import '../../modules/auth/domain/repositories/base_auth_repository.dart';
import '../../modules/auth/domain/usecases/delete_use_case.dart';
import '../../modules/auth/domain/usecases/facebook_use_case.dart';
import '../../modules/auth/domain/usecases/logout_use_case.dart';
import '../../modules/help/data/datasources/remote_data_source.dart';
import '../../modules/help/data/repositories/help_repository_impl.dart';
import '../../modules/help/domain/repositories/base_help_repository.dart';
import '../../modules/help/domain/usecases/get_chat_list_use_case.dart';
import '../../modules/help/domain/usecases/send_message_use_case.dart';
import '../../modules/help/domain/usecases/send_problem_use_case.dart';
import '../../modules/help/domain/usecases/update_message_use_case.dart';
import '../../modules/help/presentation/controller/help_bloc.dart';
import '../../modules/task/data/datasources/local_data_source.dart';
import '../../modules/task/data/repositories/task_repository_impl.dart';
import '../../modules/task/domain/repositories/base_task_repository.dart';
import '../../modules/task/domain/usecases/add_task_use_case.dart';
import '../../modules/task/domain/usecases/delete_all_tasks_use_case.dart';
import '../../modules/task/domain/usecases/delete_task_use_case.dart';
import '../../modules/task/domain/usecases/edit_task_use_case.dart';
import '../../modules/task/domain/usecases/get_task_by_id_use_case.dart';
import '../../modules/task/domain/usecases/get_tasks_use_case.dart';
import '../../modules/task/presentation/controller/task_bloc.dart';
import '../common/config/config_bloc.dart';
import '../helper/shared_helper.dart';
import 'notification_services.dart';
import 'service_settings.dart';

final sl = GetIt.instance;

class ServicesLocator {
  static Future<void> init() async {
    //Local shared
    final storage = GetStorage();
    sl.registerLazySingleton<GetStorage>(() => storage);
    sl.registerLazySingleton<AppShared>(() => AppStorage(sl()));
    //Firebase messaging
    final firebaseMessaging = FirebaseMessaging.instance;
    sl.registerLazySingleton<FirebaseMessaging>(() => firebaseMessaging);
    //Firebase auth
    final firebaseAuth = FirebaseAuth.instance;
    sl.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);
    //Firebase firestore
    final firebaseFirestore = FirebaseFirestore.instance;
    sl.registerLazySingleton<FirebaseFirestore>(() => firebaseFirestore);
    //Facebook auth
    final facebookAuth = FacebookAuth.instance;
    sl.registerLazySingleton<FacebookAuth>(() => facebookAuth);
    //Twitter login
    final twitterLogin = TwitterLogin(
      apiKey: AppConstants.twitterApiKey,
      apiSecretKey: AppConstants.twitterApiSecretKey,
      redirectURI: AppConstants.twitterRedirectURI,
    );
    sl.registerLazySingleton<TwitterLogin>(() => twitterLogin);
    //Google signIn
    final googleSignIn = GoogleSignIn(scopes: [AppConstants.googleScope]);
    sl.registerLazySingleton<GoogleSignIn>(() => googleSignIn);
    //Firebase firestore
    final firebaseStorage = FirebaseStorage.instance;
    sl.registerLazySingleton<FirebaseStorage>(() => firebaseStorage);
    //AwesomeNotifications
    final awesomeNotifications = AwesomeNotifications();
    sl.registerLazySingleton<AwesomeNotifications>(() => awesomeNotifications);
    //services
    sl.registerLazySingleton<NetworkServices>(() => InternetCheckerLookup());
    sl.registerLazySingleton<ServiceSettings>(
      () => ServiceSettingsImpl(
        sl(),
        sl(),
      ),
    );
    sl.registerLazySingleton<NotificationServices>(
      () => NotificationServicesImpl(sl()),
    );
    //DataSources
    sl.registerLazySingleton<BaseAuthRemoteDataSource>(
      () => AuthRemoteDataSource(sl(), sl(), sl(), sl(), sl(), sl()),
    );
    sl.registerLazySingleton<BaseTaskLocalDataSource>(
      () => TaskLocalDataSource.db,
    );
    sl.registerLazySingleton<BaseHelpRemoteDataSource>(
      () => HelpRemoteDataSource(sl(), sl(), sl()),
    );
    //Repositories
    sl.registerLazySingleton<BaseAuthRepository>(
        () => AuthRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton<BaseTaskRespository>(
        () => TaskRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton<BaseHelpRespository>(() => HelpRepositoryImpl(
          sl(),
          sl(),
        ));
    //UseCases
    sl.registerLazySingleton(() => LoginUseCase(sl()));
    sl.registerLazySingleton(() => SignUpUseCase(sl()));
    sl.registerLazySingleton(() => ForgetPasswordUseCase(sl()));
    sl.registerLazySingleton(() => SignInWithCredentialUseCase(sl()));
    sl.registerLazySingleton(() => FacebookUseCase(sl()));
    sl.registerLazySingleton(() => TwitterUseCase(sl()));
    sl.registerLazySingleton(() => GoogleUseCase(sl()));
    sl.registerLazySingleton(() => LogoutUseCase(sl()));
    sl.registerLazySingleton(() => DeleteUseCase(sl()));
    sl.registerLazySingleton(() => AddTaskUseCase(sl()));
    sl.registerLazySingleton(() => GetTasksUseCase(sl()));
    sl.registerLazySingleton(() => GetTaskByIdUseCae(sl()));
    sl.registerLazySingleton(() => EditTaskUseCase(sl()));
    sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));
    sl.registerLazySingleton(() => DeleteAllTasksUseCase(sl()));
    sl.registerLazySingleton(() => SendMessageUseCase(sl()));
    sl.registerLazySingleton(() => GetChatListUseCae(sl()));
    sl.registerLazySingleton(() => UpdateMessageUseCase(sl()));
    sl.registerLazySingleton(() => SendProblemUseCase(sl()));
    //blocs
    sl.registerLazySingleton(
      () => AuthBloc(
        loginUseCase: sl(),
        signUpUseCase: sl(),
        forgetPasswordUseCase: sl(),
        signInWithCredentialUseCase: sl(),
        facebookUseCase: sl(),
        twitterUseCase: sl(),
        googleUseCase: sl(),
        logoutUseCase: sl(),
        deleteUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(
      () => ConfigBloc(
        serviceSettings: sl(),
      ),
    );
    sl.registerLazySingleton(
      () => TaskBloc(
        addTaskUseCase: sl(),
        getTasksUseCase: sl(),
        getTaskByIdUseCase: sl(),
        editTaskUseCase: sl(),
        deleteTaskUseCase: sl(),
        deleteAllTasksUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(
      () => HelpBloc(
        sendMessageUseCase: sl(),
        getChatListUseCase: sl(),
        updateMessageUseCase: sl(),
        sendProblemUseCase: sl(),
      ),
    );
  }
}
