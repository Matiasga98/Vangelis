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
    'Richard Wagner': 'La imaginación crea la realidad.',
    'J.S. Bach': 'Me vi obligado a ser laborioso. Cualquiera que sea igual de laborioso triunfara de igual manera.',
    'Robert Schumann': 'Enviar luz a las tinieblas del corazón de los hombres: tal es el deber del artista.',
    'Dmitri Shostakovich': 'Un artista creativo trabaja en su siguiente composición porque no quedó satisfecho con la anterior.',
    'Mick Jagger': 'Pierde tus sueños y podrías perder la cabeza.',
    'BB King': 'Lo bonito de aprender es que nadie te lo puede quitar.',
    'Bob Marley': 'Una cosa buena de la música, cuando te golpea, no sientes dolor.',
    'Pablo Casals': 'La música es la forma divina de contar cosas bellas y poéticas al corazón.',
    'Billy Joel': 'No importa de qué cultura seamos, a todos nos gusta la música.',
    'Ludwig van Beethoven': 'La música es el suelo eléctrico en el que el espíritu vive, piensa e inventa.',
    'Franz Joseph Haydn': 'No había nadie cerca para confundirme, así que me vi obligado a ser original.',
    'Wolfgang Amadeus Mozart': 'La música no está en las notas, sino en el silencio entre ellas.',
    'Louis Armstrong': 'Los músicos no se jubilan; paran cuando ya no hay música en ellos.',
    'Beyoncé': 'Si todo fuera perfecto, nunca aprenderías y nunca crecerías.',
    'Prince': 'A pesar de todo, nadie puede dictar quién eres a los demás.',
    'James Taylor': 'Creo que los músicos tienen el deber, la responsabilidad de tender la mano, de compartir su amor o su dolor con los demás.',
    'Eddie Van Halen': 'Somos músicos. Nos ganamos la vida con la música. Es así de sencillo. Nada más importa.',
    'Bruno Mars': 'No puedes llamar a la puerta de la oportunidad y no estar preparado.',
    'Robert Fripp': 'La música es el vino que llena la copa del silencio',
    'Whitney Houston': 'Hace tiempo que decidí no caminar nunca a la sombra de nadie; si fracaso, o si tengo éxito, al menos hice lo que creo.',
    'Madonna': 'Una cosa que he aprendido es que no soy el dueño de mi talento; soy su gestor.',
    'Paul McCartney': '¿Por qué iba a retirarme? ¿Para sentarme en casa y ver la televisión? No, gracias. Prefiero estar afuera tocando.',
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
