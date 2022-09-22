import 'package:backend/src/core/core_module.dart';
import 'package:backend/src/features/auth/auth_module.dart';
import 'package:backend/src/features/user/user_resource.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'features/swagger/swagger_handler.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.get('/', (Request request) => Response.ok('Hello World!')),
        Route.get('/documentation/**', swaggerHandler),
        Route.resource(UserResource()),
        Route.module('/auth', module: AuthModule()),
      ];
}
