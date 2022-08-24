import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double greenSize;
  final double redSize;
  const ProgressBar({required this.greenSize,required this.redSize,Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;


    return Center(
      child: MyAssetsBar(
        width: width * .85,
        background: lightGreyColor,
        //height: 50,
        //radius: 10,
        assetsLimit: 100,
        // order: OrderType.Ascending,
        assets: [
          MyAsset(size: greenSize*100, color: lightGreenColor),
          MyAsset(size: redSize*100, color: pinkColor),
        ],
      ),
    );
  }
}

const double _kHeight = 15;
enum OrderType { Ascending, Descending, None }
/*Utils*/

class MyAsset {
  final double size;
  final Color color;

  MyAsset({required this.size, required this.color});
}

class MyAssetsBar extends StatelessWidget {
  const MyAssetsBar(
      {Key? key,
      @required this.width,
      this.height = _kHeight,
      this.radius,
      this.assets,
      this.assetsLimit,
      this.order,
      this.background = Colors.grey})
      : assert(width != null),
        assert(assets != null),
        super(key: key);

  final double? width;
  final double height;
  final double? radius;
  final List<MyAsset>? assets;
  final double? assetsLimit;
  final OrderType? order;
  final Color background;

  double _getValuesSum() {
    double sum = 0;
    assets?.forEach((single) => sum += single.size);
    return sum;
  }

  void orderMyAssetsList() {
    switch (order) {
      case OrderType.Ascending:
        {
          //From the smallest to the largest
          assets?.sort((a, b) {
            return a.size.compareTo(b.size);
          });
          break;
        }
      case OrderType.Descending:
        {
          //From largest to smallest
          assets?.sort((a, b) {
            return b.size.compareTo(a.size);
          });
          break;
        }
      case OrderType.None:
      default:
        {
          break;
        }
    }
  }

  //single.size : assetsSum = x : width
  Widget _createSingle(MyAsset singleAsset) {
    return SizedBox(
      width: (singleAsset.size * width!) / (assetsLimit ?? _getValuesSum()),
      child: Container(color: singleAsset.color),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (assetsLimit != null && assetsLimit! < _getValuesSum()) {
      return Container();
    }

    //Order assetsList
    orderMyAssetsList();

    final double rad = radius ?? (height / 2);

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(rad)),
      child: Container(
        decoration: new BoxDecoration(
          color: background,
        ),
        width: width,
        height: height,
        child: Row(
            children: assets!
                .map((singleAsset) => _createSingle(singleAsset))
                .toList()),
      ),
    );
  }
}
