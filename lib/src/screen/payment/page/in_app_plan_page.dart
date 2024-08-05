/*import 'package:flutter/material.dart';
class InAppPlanDetail extends StatelessWidget {
  const InAppPlanDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}*/

import 'dart:async';
import 'dart:io';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import '../../../../resrc/utils/ui_helper.dart';
import '../../../utils/colors/colors.dart';
import '../../material/controller/materialController.dart';
import '../../profile/controller/profile_controllers.dart';
import '../controller/paymentController.dart';
import 'consumable_store.dart';

// Auto-consume must be true on iOS.
// To try without auto-consume on another platform, change `true` to `false` here.
final bool _kAutoConsume = Platform.isIOS || true;

const String one_month_english = 'com.EngMadhyam.englishMadhyam.onemonthplan';
const String three_month_english = 'com.EngMadhyam.englishMadhyam.threemonthplan';
const String twelv_month_english = 'com.EngMadhyam.englishMadhyam.twelvemonthplan';
const String six_month_english = 'com.EngMadhyam.englishMadhyam.sixmonthplan';
final PaymentController _paymentController = Get.put(PaymentController());

const List<String> _kProductIds = <String>[
  one_month_english,
  three_month_english,
  six_month_english,
  twelv_month_english
];

class InAppPlanDetail extends StatefulWidget {
  @override
  State<InAppPlanDetail> createState() => _InAppPlanDetailState();
}

class _InAppPlanDetailState extends State<InAppPlanDetail> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  final ProfileControllers _profileControllers = Get.put(ProfileControllers());
  final MaterialController planDetailsController =
  Get.put<MaterialController>(MaterialController());



  List<String> _consumables = <String>[];

  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;
  var selectedPrice = "";

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
          _listenToPurchaseUpdated(purchaseDetailsList);
        }, onDone: () {
          _subscription.cancel();
        }, onError: (Object error) {
          // handle error here.
        });
    initStoreInfo();
    planDetailsController.getPlanDetails();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
      _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
    await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    print(productDetailResponse.productDetails.length.toString());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
      _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    _loading = false;
    super.dispose();
  }

  Future<void> _handlePaymentSuccess(
      PurchaseDetails purchaseDetails, String? transactionIdentifier) async {
    setState(() {
      _loading = true;
    });
    var dataResponse = await _paymentController.confirmPayment(
        pay: transactionIdentifier ?? "",
        amount: selectedPrice,
        PlanID: purchaseDetails.productID == _kProductIds[0]
            ? planDetailsController.planIdOneMonth
            : purchaseDetails.productID == _kProductIds[1]
            ? planDetailsController.planIdThreeMonth:
        purchaseDetails.productID == _kProductIds[2]?planDetailsController.planIdSixMonth
            : planDetailsController.planIdOneYear,
        paymentMethod: "in_app_purchase");
    setState(() {
      _loading = false;
    });
    if (dataResponse?.result == true) {
      UiHelper.showSnakbarSucess(
          context, "You have Successfully purchased Subscription");
      await _profileControllers.profileDataFetch();
      Get.back();
    } else {
      UiHelper.showSnakbarMsg(context, dataResponse?.message ?? "");
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> stack = <Widget>[];
    if (_queryProductError == null) {
      stack.add(
        ListView(
          children: <Widget>[
            _buildProductList(),
            // _buildRestoreButton(),
          ],
        ),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError!),
      ));
    }
    if (_purchasePending) {
      stack.add(
        // ignore: prefer_const_constructors
        Stack(
          children: const <Widget>[
            Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        //backgroundColor: Colors.transparent,
        centerTitle: false,
        titleSpacing: 0,
        title: const ToolbarTitle(title: "Subscription Plan",),
      ),
      body: Stack(
        children: stack,
      ),
    );
  }

  Card _buildProductList() {
    if (_loading) {
      return const Card(
          child: ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching Plan...')));
    }
    if (!_isAvailable) {
      return const Card();
    }
    const ListTile productHeader = ListTile(title: Text('Select plan'));
    final List<Container> productList = <Container>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        padding:
        const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff5853F5), width: 2),
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
                colors: [
                  Color(0xff5853F5),
                  Color(0xff7581F5),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 2])),
        child: ListTile(
            title: Text('[${_notFoundIds.join(", ")}] not found',
                style: TextStyle(color: ThemeData.light().colorScheme.error)),
            subtitle: const Text(
                'This app needs special configuration to run. Please see example/README.md for instructions.')),
      ));
    }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verify the purchase data.
    final Map<String, PurchaseDetails> purchases =
    Map<String, PurchaseDetails>.fromEntries(
        _purchases.map((PurchaseDetails purchase) {
          if (purchase.pendingCompletePurchase) {
            _inAppPurchase.completePurchase(purchase);
          }
          return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
        }));
    productList.addAll(_products.map(
          (ProductDetails productDetails) {
        final PurchaseDetails? previousPurchase = purchases[productDetails.id];
        return Container(
          margin: const EdgeInsets.only(bottom: 20, left: 12, right: 12),
          padding:
          const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
          decoration: BoxDecoration(
            //color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(18),
            ),
          child: ListTile(
            title: Text(
              productDetails.title,
            ),
            subtitle: Text(
              productDetails.description,
            ),
            trailing: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green[800],
              ),
              onPressed: () {
                selectedPrice = productDetails.price;
                late PurchaseParam purchaseParam;
                purchaseParam = PurchaseParam(
                  productDetails: productDetails,
                );
                if (_kProductIds.contains(productDetails.id)) {
                  _inAppPurchase.buyConsumable(
                      purchaseParam: purchaseParam, autoConsume: _kAutoConsume);
                } else {
                  _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
                }
              },
              child: Text(productDetails.price),
            ),
          ),
        );
      },
    ));

    return Card(
        child: Column(
            children: <Widget>[productHeader, const Divider()] + productList));
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (_kProductIds.contains(purchaseDetails.productID)) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      final List<String> consumables = await ConsumableStore.load();
      var purchaseID = purchaseDetails.purchaseID;
      if (purchaseDetails is AppStorePurchaseDetails) {
        final originalTransaction =
            purchaseDetails.skPaymentTransaction.originalTransaction;
        if (originalTransaction != null) {
          purchaseID = originalTransaction.transactionIdentifier;
          //print("purchaseID-:$purchaseID");
          _handlePaymentSuccess(purchaseDetails,
              originalTransaction.transactionIdentifier ?? purchaseID);
        } else {
          _handlePaymentSuccess(purchaseDetails,
              originalTransaction?.transactionIdentifier ?? purchaseID);
          //print("purchaseID2-:$purchaseID");
        }
      }
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
      _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  Future<void> restorePlan() async {
    var paymentWrapper = SKPaymentQueueWrapper();
    var transactions = await paymentWrapper.transactions();
    transactions.forEach((transaction) async {
      await paymentWrapper.finishTransaction(transaction);
    });
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
        setState(() {
          _purchasePending=false;
        });
        restorePlan();

        // showPendingUI();
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        setState(() {
          _purchasePending = false;
        });
        restorePlan();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          setState(() {
            _purchasePending = false;
          });
          handleError(purchaseDetails.error!);
          restorePlan();
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          deliverProduct(purchaseDetails);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
