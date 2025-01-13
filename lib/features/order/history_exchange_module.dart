import 'package:flutter_modular/flutter_modular.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/home/domain/entities/general_item_data.dart';
import 'package:fms/features/order/domain/entities/order_entity.dart';
import 'package:fms/features/order/domain/usecases/delete_order_usecase.dart';
import 'package:fms/features/order/order_module.dart';
import 'package:fms/features/order/presentation/cubit/delete_order_cubit.dart';
import 'package:fms/features/order/presentation/cubit/verification_code_cubit.dart';
import 'package:fms/features/order/presentation/pages/order_page.dart';
import 'package:fms/features/order/presentation/pages/sms_otp_page.dart';

import '../../routes/routes.dart';
import 'domain/usecases/get_order.usecase.dart';
import 'presentation/cubit/get_order_cubit.dart';
import 'presentation/cubit/history_exchange_cubit.dart';
import 'presentation/pages/barcode_scanner_page.dart';
import 'presentation/pages/history_exchange_detail.dart';
import 'presentation/pages/history_exchange_page.dart';
import 'presentation/pages/success_page.dart';

class HistoryExchangeModule extends Module {
  static const String route = '/historyExchange/';
  static const String historyDetail = 'history_detail';
  static const String edit = 'history_edit';
  static const String smsOTP = 'sms_otp';
  static const String updateSuccess = 'update_success';

  static const String productBarcodeScanner = 'product_barcode_scanner';
  @override
  List<Module> get imports => [OrderModule()];
  @override
  void binds(Injector i) {
    i.addLazySingleton(DeleteOrderUsecase.new);
    i.addLazySingleton(GetOrderUsecase.new);
    i.add(HistoryExchangeCubit.new);
    i.add(DeleteOrderCubit.new);
    i.add(GetOrderCubit.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Routes.root,
      child: (_) => HistoryExchangePage(
        entity: r.args.data as GeneralFeatureData,
      ),
    );

    r.child(
      Routes.root + historyDetail,
      child: (_) => HistoryExchangeDetailPage(
          feature: r.args.data[0] as FeatureEntity,
          order: r.args.data[1] as OrderEntity),
    );

    r.child(
      Routes.root + edit,
      child: (_) => OrderPage(
          entity: r.args.data[0] as GeneralFeatureData,
          order: r.args.data[1] as OrderEntity),
    );
    r.child(
      Routes.root + smsOTP,
      child: (_) => SmsOTPPage(
        verificationCodeCubit: r.args.data[0] as VerificationCodeCubit,
        identifyFields: r.args.data[1] as List<CustomerInfo>,
        attendanceId: r.args.data[2] as int,
        featureId: r.args.data[3] as int,
        countDown: r.args.data[4] as int,
      ),
    );
    r.child(
      Routes.root + productBarcodeScanner,
      child: (_) => BarcodeScanner(),
    );
    r.child(
      Routes.root + updateSuccess,
      child: (_) => SuccessPage(
        isUpdate: true,
      ),
    );
  }
}
