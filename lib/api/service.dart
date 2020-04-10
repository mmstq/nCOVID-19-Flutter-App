import 'package:COVID19/api/covid_api.dart';
import 'package:COVID19/notifiers/country_notifier.dart';
import 'package:COVID19/notifiers/graph_notifier.dart';
import 'package:COVID19/notifiers/headline_notifier.dart';
import 'package:COVID19/api/middleware.dart';
import 'package:COVID19/notifiers/homescreen_notifier.dart';
import 'package:COVID19/notifiers/states_notifier.dart';
import 'package:get_it/get_it.dart';

final GetIt service = GetIt.instance;

void setupLocator(){
  service.registerFactory(() => HomeNotifier());
  service.registerFactory(() => StatesNotifier());
  service.registerFactory(() => GraphNotifier());
  service.registerFactory(() => CountryNotifier());
  service.registerFactory(() => HeadlineNotifier());
  service.registerLazySingleton(() => NoteAPI());
  service.registerLazySingleton(() => MiddleWare());
}