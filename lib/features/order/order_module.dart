import 'package:flutter_modular/flutter_modular.dart';
import 'package:fms/features/home/domain/entities/general_item_data.dart';
import 'package:fms/features/images/image_module.dart';
import 'package:fms/features/order/data/datasources/order_local_datasource.dart';
import 'package:fms/features/order/data/repositories/order_repository_impl.dart';
import 'package:fms/features/order/domain/entities/order_entity.dart';
import 'package:fms/features/order/domain/usecases/cancel_order_usecase.dart';
import 'package:fms/features/order/domain/usecases/create_order_usecase.dart';
import 'package:fms/features/order/domain/usecases/get_lucky_draw_usecase.dart';
import 'package:fms/features/order/domain/usecases/get_orders_no_synced_usecase.dart';
import 'package:fms/features/order/domain/usecases/get_orders_not_completed_usecase.dart';
import 'package:fms/features/order/domain/usecases/get_orders_usecase.dart';
import 'package:fms/features/order/domain/usecases/get_otp_usecase.dart';
import 'package:fms/features/order/domain/usecases/identify_customer_usecase.dart';
import 'package:fms/features/order/domain/usecases/send_otp_usecase.dart';
import 'package:fms/features/order/presentation/cubit/cancel_order_cubit.dart';
import 'package:fms/features/order/presentation/cubit/identify_cubit.dart';
import 'package:fms/features/order/presentation/cubit/lucky_draw_cubit.dart';
import 'package:fms/features/order/presentation/cubit/verification_code_cubit.dart';
import 'package:fms/features/order/presentation/pages/barcode_scanner_page.dart';
import 'package:fms/features/order/presentation/pages/sms_otp_page.dart';

import '../../routes/routes.dart';
import 'data/datasources/order_remote_datasource.dart';
import 'domain/usecases/identify_customer_limit_usecase.dart';
import 'domain/usecases/update_order_usecase.dart';
import 'presentation/bloc/order_bloc.dart';
import 'presentation/cubit/identify_with_limits_cubit.dart';
import 'presentation/pages/order_page.dart';
import 'presentation/pages/success_page.dart';

class OrderModule extends Module {
  static const String route = '/customerInformationCapturing/';
  static const String productBarcodeScanner = 'product_barcode_scanner';
  static const String smsOTP = 'sms_otp';
  static const String success = 'success';

  @override
  List<Module> get imports => [ImageModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton(OrderLocalDataSource.new);
    i.addLazySingleton(OrderRemoteDataSource.new);
    i.addLazySingleton(OrderRepositoryImpl.new);
    i.addLazySingleton(IdentifyCustomerUsecase.new);
    i.addLazySingleton(IdentifyCustomerWithLimitsUsecase.new);
    i.addLazySingleton(GetOrdersNoSyncedDataUsecase.new);
    i.addLazySingleton(GetOrdersNotCompletedUsecase.new);
    i.addLazySingleton(GetOrdersUsecase.new);
    i.addLazySingleton(CreateOrderUsecase.new);
    i.addLazySingleton(UpdateOrderUsecase.new);
    i.addLazySingleton(CancelOrderUsecase.new);
    i.addLazySingleton(GetOtpUsecase.new);
    i.addLazySingleton(SendOtpUsecase.new);
    i.addLazySingleton(GetLuckyDrawUsecase.new);
    i.add(IdentifyCubit.new);
    i.add(IdentifyWithLimitsCubit.new);
    i.add(OrderBloc.new);
    i.add(CancelOrderCubit.new);
    i.add(VerificationCodeCubit.new);
    i.add(LuckyDrawCubit.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Routes.root,
      child: (_) => OrderPage(
        entity: r.args.data as GeneralFeatureData,
      ),
    );
    r.child(
      Routes.root + productBarcodeScanner,
      child: (_) => BarcodeScanner(),
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
      Routes.root + success,
      child: (_) => SuccessPage(
        generalFeature: r.args.data as GeneralFeatureData,
      ),
    );
  }
}
