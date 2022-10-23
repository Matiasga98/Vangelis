import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import '../../model/quote_data.dart';
import '../../services/auth_service.dart';
import '../dashboard/dashboard_controller.dart';
import '../dashboard/dashboard_page.dart';
import '../login/login_page.dart';

class SplashController extends GetxController {
  late bool? isLoggedIn;
  AuthService authService = Get.find();
  Rx<Quote?> quote = Quote().obs;

  Map<String, String> quotes = {
    'Richard Wagner': 'Imagination creates reality.',
    'J.S. Bach': 'I was obliged to be industrious. Whoever is equally industrious will succeed equally well.',
    'Robert Schumann': 'To send light into the darkness of men\'s hearts - such is the duty of the artist.',
    'Dmitri Shostakovich': 'A creative artist works on his next composition because he was not satisfied with his previous one.',
    'Mick Jagger': 'Lose your dreams and you might lose your mind.',
    'BB King': 'The beautiful thing about learning is that nobody can take it away from you.',
    'Bob Marley': 'One good thing about music, when it hits you, you feel no pain.',
    'Pablo Casals': 'Music is the divine way to tell beautiful, poetic things to the heart.',
    'Billy Joel': 'No matter what culture we\'re from, everyone loves music.',
    'Ludwig van Beethoven': 'Music is the electrical soil in which the spirit lives, thinks and invents.',
    'Franz Joseph Haydn': 'There was no one near to confuse me, so I was forced to become original.',
    'Wolfgang Amadeus Mozart': 'The music is not in the notes, but in the silence between.',
    'Louis Armstrong': 'Musicians don’t retire; they stop when there’s no more music in them.',
    'Beyoncé': 'If everything was perfect, you would never learn and you would never grow.',
    'Prince': 'Despite everything, no one can dictate who you are to other people.',
    'James Taylor': 'I believe musicians have a duty, a responsibility to reach out, to share your love or pain with others.',
    'Eddie Van Halen': 'We’re musicians. We make music for a living. It’s that simple. Nothing else matters.',
    'Bruno Mars': 'You can’t knock on opportunity’s door and not be ready.',
    'Robert Fripp': 'Music is the wine that fills the cup of silence',
    'Whitney Houston': 'I decided long ago never to walk in anyone’s shadow; if I fail, or if I succeed at least I did as I believe.',
    'Madonna': 'One thing I’ve learned is that I’m not the owner of my talent; I’m the manager of it.',
    'Paul McCartney': 'Why would I retire? Sit at home and watch TV? No thanks. I’d rather be out playing.',
  };


  int animationTimer = 3000;

  bool? isInit;

  SplashController({this.isInit});

  @override
  void onInit() {
    if (isInit ?? true) {
      checkLogin();
    }

    super.onInit();
  }

  Future<void> getQuote() async {
    Random random = Random();
    int index = random.nextInt(quotes.length-1);
    quote.value = Quote(author: quotes.keys.elementAt(index), quote: quotes.values.elementAt(index));
  }

  void checkLogin() async {
    isLoggedIn = await authService.isLogged();
    await getQuote();
    await startAnimation();
  }

  Future<void> startAnimation() async {
    await Future.delayed(Duration(milliseconds: animationTimer), () async {
      navigate();
    });
  }

  void navigate() async {
    if (isLoggedIn!) {
      if (isInit ?? true) {
        Get.put(DashboardController(), permanent: true);
        Get.off(() => DashboardPage(),
            transition: Transition.fadeIn, duration: const Duration(milliseconds: 800));
      }
    } else {
      Get.off(() => LoginPage(),
          transition: Transition.fadeIn, duration: const Duration(milliseconds: 800));
    }
  }
}
