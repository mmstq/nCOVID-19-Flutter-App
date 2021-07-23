import 'package:covid19/api/covid_api.dart';
import 'package:covid19/notifiers/country_notifier.dart';
import 'package:covid19/notifiers/graph_notifier.dart';
import 'package:covid19/notifiers/headline_notifier.dart';
import 'package:covid19/api/middleware.dart';
import 'package:covid19/notifiers/homescreen_notifier.dart';
import 'package:covid19/notifiers/states_notifier.dart';
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