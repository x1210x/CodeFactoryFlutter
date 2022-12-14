import 'package:badges/badges.dart';
import 'package:codefactory_flutter/common/const/colors.dart';
import 'package:codefactory_flutter/common/layout/default_layout.dart';
import 'package:codefactory_flutter/common/model/cursor_pagination_model.dart';
import 'package:codefactory_flutter/common/utils/pagination_utils.dart';
import 'package:codefactory_flutter/product/component/product_card.dart';
import 'package:codefactory_flutter/product/model/product_model.dart';
import 'package:codefactory_flutter/rating/component/rating_card.dart';
import 'package:codefactory_flutter/rating/model/rating_model.dart';
import 'package:codefactory_flutter/restaurant/component/restaurant_card.dart';
import 'package:codefactory_flutter/restaurant/model/restaurant_detail_model.dart';
import 'package:codefactory_flutter/restaurant/model/restaurant_model.dart';
import 'package:codefactory_flutter/restaurant/provider/restaurant_provider.dart';
import 'package:codefactory_flutter/restaurant/provider/restaurant_rating_provider.dart';
import 'package:codefactory_flutter/restaurant/view/basket_screen.dart';
import 'package:codefactory_flutter/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static const routeName = "/restaurantDetail";

  const RestaurantDetailScreen({required this.id, super.key});

  final String id;

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen> {

  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    controller.addListener(listener);
  }
  
  void listener() {
    PaginationUtils.paginate(
        controller: controller,
        provider: ref.read(restaurantRatingProvider(widget.id).notifier)
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);

    if (state == null) {
      return DefaultLayout(child: Center(child: CircularProgressIndicator()));
    }
    return DefaultLayout(
      title: '????????? ?????????',
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(BasketScreen.routeName);
        },
        backgroundColor: PRIMARY_COLOR,
        child: Badge(
          showBadge: basket.isNotEmpty,
          badgeContent: Text(
            '${basket.fold<int>(0, (previousValue, element) => previousValue + element.count)}',
            style: const TextStyle(color: PRIMARY_COLOR, fontSize: 10)
          ),
          badgeColor: Colors.white,
          child: const Icon(Icons.shopping_basket_sharp)
        )
      ),
      child: CustomScrollView(
        controller: controller,
        slivers: [
          renderTop(model: state),
          if (state is! RestaurantDetailModel)
            renderLoading(),
          if (state is RestaurantDetailModel)
            renderLabel(),
          if (state is RestaurantDetailModel)
            renderProducts(products: state.products, restaurant: state),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRatings(models: ratingsState.data)
        ],
      )
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantModel model
  }) {
    return SliverToBoxAdapter(
        child : RestaurantCard.fromModel(model: model, isDetail: true)
    );
  }

  SliverPadding renderRatings({required List<RatingModel> models}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((_, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: RatingCard.fromModel(model: models[index]));
          },
          childCount: models.length
        ),
      )
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(3, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: SkeletonParagraph(
              style: const SkeletonParagraphStyle(
                lines: 5,
                padding: EdgeInsets.zero,
              ),
          )))
        )
      )
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Text('??????', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18))
      )
    );
  }

  renderProducts({
    required RestaurantModel restaurant,
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];
            return InkWell(
              onTap: () {
                ref.read(basketProvider.notifier).addToBasket(
                  product: ProductModel(
                      id: model.id,
                      name: model.name,
                      detail: model.detail,
                      imgUrl: model.imgUrl,
                      price: model.price,
                      restaurant: restaurant
                  )
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ProductCard.fromRestaurantProductModel(model: model)
              )
            );
          },
          childCount: products.length
        )
    )
    );
  }
}