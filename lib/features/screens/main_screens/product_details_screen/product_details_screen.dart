import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:valura/features/data/blocs/product_details_bloc/product_details_bloc.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/screens/main_screens/add_item_screen/widgets/item_part_card.dart';
import 'package:valura/features/screens/main_screens/edit_item_screen/edit_item_screen.dart';
import 'package:valura/helpers/popup_helpers.dart';
import 'package:valura/packages/sqflite_package/sqflite_codes.dart';
import 'package:valura/packages/toast_package/toast_package.dart';
import 'package:valura/utils/size_constant.dart';
import 'package:valura/widgets/custom_aligned_grid_view.dart';
import 'package:valura/widgets/custom_appbar.dart';
import 'package:valura/widgets/loading_cover.dart';
import 'package:valura/widgets/try_again_btn.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String id = '/product_details_screen';
  static const String name = 'product_details';
  const ProductDetailsScreen({super.key, required this.productId, required this.productName});
  final int productId;
  final String productName;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    try {
      context.read<ProductDetailsBloc>().add(FetchProductDetails(id: widget.productId));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(title: widget.productName, showBackBtn: true),
          Expanded(
            child: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
              listener: (context, state) {
                if (state is FetchProductDetailsFailure) {
                  ToastPackage.showSimpleToast(context: context, message: getErrorMessage(state.errorMessage));
                } else if (state is DeleteProductDetailFailure) {
                  ToastPackage.showSimpleToast(context: context, message: getErrorMessage(state.errorMessage));
                } else if (state is DeleteProductDetailSuccess) {
                  if (state.message == SqfliteCodes.successCodeWithDelete) {
                    context.pop();
                  }
                }
              },
              builder: (context, state) {
                if (state is FetchingProductDetails) {
                  return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor));
                } else if (state is FetchProductDetailsSuccess) {
                  List<ItemModel> items = state.details;
                  return Stack(
                    children: [
                      CustomAlignedGridView(
                        paddings: EdgeInsets.symmetric(horizontal: sizeConstants.spacing8, vertical: sizeConstants.spacing12),
                        itemBuilder: (context, index) {
                          ItemModel item = items[index];
                          return ItemPartCard(
                            item: item,
                            onEditTap: (context) {
                              try {
                                context.push(EditItemScreen.id, extra: {'item_model': item, 'p_id': widget.productId});
                              } catch (_) {}
                            },
                            onDeleteTap: (mContext) {
                              try {
                                PopupHelpers.showYesOrNoDialog(
                                  context: context,
                                  title: 'جزئیات انتخاب شده را حذف میکنید؟',
                                  onYesTap: (bCtx) {
                                    context.read<ProductDetailsBloc>().add(DeleteProductDetail(id: item.id, pId: widget.productId));
                                    bCtx.pop();
                                  },
                                );
                              } catch (_) {}
                            },
                          );
                        },
                        length: items.length,
                        crossAxisCount: 1,
                      ),
                      if (state is DeletingProductDetail) Positioned.fill(child: LoadingCover()),
                    ],
                  );
                } else {
                  return Center(
                    child: TryAgainBtn(
                      onTryAgain: () {
                        try {
                          context.read<ProductDetailsBloc>().add(FetchProductDetails(id: widget.productId));
                        } catch (_) {}
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
