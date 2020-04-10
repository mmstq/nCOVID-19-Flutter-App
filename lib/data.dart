import 'package:flutter/material.dart';


enum NoteStates {Busy, Idle, Done}

class Data {

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext buildContext;

  static final Map<int, Color> color = {
    50: Color.fromRGBO(4, 131, 184, .1),
    100: Color.fromRGBO(4, 131, 184, .2),
    200: Color.fromRGBO(4, 131, 184, .3),
    300: Color.fromRGBO(4, 131, 184, .4),
    400: Color.fromRGBO(4, 131, 184, .5),
    500: Color.fromRGBO(4, 131, 184, .6),
    600: Color.fromRGBO(4, 131, 184, .7),
    700: Color.fromRGBO(4, 131, 184, .8),
    800: Color.fromRGBO(4, 131, 184, .9),
    900: Color.fromRGBO(4, 131, 184, 1),
  };

  static final list = [
    'Regularly and thoroughly clean your hands COVIDwith an alcohol-based hand rub or wash them with soap and water.',
    'Maintain at least 1 metre (3 feet) distance between yourself and anyone who is coughing or sneezing',
    'Stay home if you feel unwell. If you have a fever, cough and difficulty breathing, seek medical attention and call in advance',
    'Self-isolate by staying at home if you begin to feel unwell, even with mild symptoms such as headache, low grade fever (37.3 C or above) and slight runny nose, until you recover',
    '“incubation period” means the time between catching the virus and beginning to have symptoms of the disease. The incubation period for COVID-19 range from 1-14 days',
    'Most people (about 80%) recover from the disease without needing special treatment',
    'Antibiotics do not work against viruses, they only work on bacterial infections. COVID-19 is caused by a virus, so antibiotics do not work.',
    'Only wear a mask if you are ill with COVID-19 symptoms. Disposable face mask can only be used once. If you are not ill or looking after someone who is ill then you are wasting a mask.',
    "Don'ts\n1. Wearing multiple masks\n2. Taking antibiotics\n3. Touching face",
    'The virus that causes COVID-19 is mainly transmitted through droplets generated when an infected person coughs, sneezes, or speaks. These droplets are too heavy to hang in the air. They quickly fall on floors or surfaces.',
  ];

}
