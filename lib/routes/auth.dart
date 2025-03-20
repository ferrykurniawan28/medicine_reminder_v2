part of 'routes.dart';

class AuthRoutes extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const Login());
    r.child('/register', child: (_) => const Register());
  }
}
