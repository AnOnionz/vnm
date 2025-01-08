import 'package:flutter_modular/flutter_modular.dart';
import 'package:vnm/features/home/domain/entities/general_item_data.dart';
import 'package:vnm/features/order/domain/entities/order_entity.dart';
import 'package:vnm/features/order/order_module.dart';
import 'package:vnm/features/order/presentation/pages/lucky_wheel.dart';
import 'package:vnm/features/order/presentation/pages/lucky_wheel_summary_page.dart';
import 'package:vnm/features/order/presentation/pages/success_page.dart';
import 'package:vnm/routes/routes.dart';

class LuckyWheelModule extends Module {
  static const String route = '/luckyWheel/';
  static const String summary = 'luckyWheelSummary';
  static const String success = 'success';
  static const String editingSuccess = 'editing_success';

  @override
  List<Module> get imports => [OrderModule()];

  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child(
      Routes.root,
      child: (_) => LuckyWheelPage(
        generalFeature: r.args.data[0] as GeneralFeatureData,
        order: r.args.data[1] as OrderEntity,
        isEditing: r.args.data[2] as bool,
      ),
    );
    r.child(
      Routes.root + summary,
      child: (_) => LuckyWheelSummaryPage(
        generalFeature: r.args.data[0] as GeneralFeatureData,
        order: r.args.data[1] as OrderEntity,
        isEditing: r.args.data[2] as bool,
      ),
    );
    r.child(
      Routes.root + success,
      child: (_) => SuccessPage(
        generalFeature: r.args.data as GeneralFeatureData,
      ),
    );
    r.child(
      Routes.root + editingSuccess,
      child: (_) => SuccessPage(
        generalFeature: r.args.data as GeneralFeatureData,
        isUpdate: true,
      ),
    );
  }
}
