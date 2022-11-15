import 'package:codefactory_flutter/common/const/data.dart';
import 'package:codefactory_flutter/restaurant/component/restaurant_card.dart';
import 'package:codefactory_flutter/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../main.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginateRestaurant() async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    print('restaurant accessToken = $accessToken');
    final resp = await dio.get('http://$ip/restaurant',
      options: Options(
        headers: {
          'authorization' : 'Bearer $accessToken,'
        }
      )
    );
    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder<List>(
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              return ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final item = snapshot.data!.elementAt(index);
                  final pItem = RestaurantModel(
                      id: item['id'],
                      name: item['name'],
                      thumbUrl: item['thumbUrl'],
                      tags: List<String>.from(item['tags']),
                      priceRange: RestaurantPriceRange.values.firstWhere(
                        (e) => e.name == item['priceRange']
                      ),
                      ratings: item['ratings'],
                      ratingsCount: item['ratingsCount'],
                      deliveryFee: item['deliveryFee'],
                      deliveryTime: item['deliveryTime']
                  );
                  return RestaurantCard(
                    image: Image.network('http://${ip}${pItem.thumbUrl}', fit: BoxFit.cover),
                    name: pItem.name,
                    tags: pItem.tags,
                    ratingsCount: pItem.ratingsCount,
                    deliveryTime: pItem.deliveryTime,
                    deliveryFee: pItem.deliveryFee,
                    ratings: pItem.ratings,
                  );
                },
                separatorBuilder: (_, index) {
                  return SizedBox(height: 16);
                },
              );
            },
          )
        )
      )
    );
  }

}