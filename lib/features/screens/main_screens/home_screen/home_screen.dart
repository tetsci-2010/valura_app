import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/constants/images_paths.dart';
import 'package:valura/features/data/blocs/home_bloc/home_bloc.dart';
import 'package:valura/features/data/enums/sort.dart';
import 'package:valura/features/data/models/product_model.dart';
import 'package:valura/features/data/providers/app_provider.dart';
import 'package:valura/features/data/providers/home_provider.dart';
import 'package:valura/features/screens/main_screens/backup_screen/backup_screen.dart';
import 'package:valura/features/screens/main_screens/home_screen/widgets/home_product_model_card.dart';
import 'package:valura/features/screens/main_screens/product_details_screen/product_details_screen.dart';
import 'package:valura/helpers/bottom_sheet_helper.dart';
import 'package:valura/helpers/popup_helpers.dart';
import 'package:valura/packages/sqflite_package/sqflite_codes.dart';
import 'package:valura/packages/toast_package/toast_package.dart';
import 'package:valura/utils/size_constant.dart';
import 'package:valura/widgets/bottom_sheet_item.dart';
import 'package:valura/widgets/custom_aligned_grid_view.dart';
import 'package:valura/widgets/custom_appbar.dart';
import 'package:valura/widgets/try_again_btn.dart';

class HomeScreen extends StatelessWidget {
  static const String id = '/home_screen';
  static const String name = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomAppbar(
            child: Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(1000),
                  onTap: () {
                    try {
                      context.push(BackupScreen.id);
                    } catch (_) {}
                  },
                  child: Hero(
                    tag: 'image',
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(color: kWhiteColor),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: CircleAvatar(
                        maxRadius: sizeConstants.avatarSmall,
                        minRadius: sizeConstants.avatarSmall,
                        backgroundImage: AssetImage(ImagesPaths.valuraTextJpg),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: sizeConstants.spacing12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'سلام، چطوری؟',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: kWhiteColor,
                          ),
                        ),
                        SizedBox(width: sizeConstants.spacing8),
                        Transform.flip(
                          flipX: true,
                          child: Icon(
                            Icons.waving_hand_rounded,
                            color: kOrangeAccentColor,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'به والورا خوش آمدید!',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: kWhiteColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is FetchProductsFailure) {
                ToastPackage.showSimpleToast(context: context, message: getErrorMessage(state.errorMessage));
              }
            },
            builder: (context, state) {
              if (state is FetchingProducts) {
                return Expanded(
                  child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)),
                );
              } else if (state is FetchProductsSuccess) {
                List<ProductModel> products = state.products;
                if (products.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('هیج تولیدی موجود نیست.'),
                          SizedBox(height: sizeConstants.spacing16),
                          TryAgainBtn(
                            onTryAgain: () {
                              try {
                                context.read<HomeBloc>().add(FetchProducts());
                              } catch (_) {}
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing16, vertical: sizeConstants.spacing8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
                            onTap: () {
                              try {
                                BottomSheetHelper.showBottomSheet(
                                  context: context,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      BottomSheetItem(
                                        title: 'ترتیب لیست',
                                        color: kBlueColor,
                                        icon: HomeBloc.sort == Sort.ascending ? CupertinoIcons.sort_down : CupertinoIcons.sort_up,
                                        onTap: () {
                                          try {
                                            context.pop();
                                            if (HomeBloc.sort == Sort.ascending) {
                                              context.read<HomeBloc>().add(FetchProducts(sort: Sort.descending));
                                            } else {
                                              context.read<HomeBloc>().add(FetchProducts(sort: Sort.ascending));
                                            }
                                          } catch (_) {}
                                        },
                                      ),
                                      BottomSheetItem(
                                        title: 'تغییر چینش',
                                        color: kGreenColor,
                                        icon: CupertinoIcons.list_bullet_below_rectangle,
                                        onTap: () {
                                          try {
                                            context.read<HomeProvider>().toggleBuilderLayout();
                                            context.pop();
                                          } catch (_) {}
                                        },
                                      ),
                                      BottomSheetItem(
                                        title: 'خالی کردن لیست',
                                        color: kRedColor,
                                        icon: CupertinoIcons.delete,
                                        bottom: true,
                                        onTap: () {
                                          try {
                                            PopupHelpers.showYesOrNoDialog(
                                              context: context,
                                              title: 'لیست تولید را پاک میکنید؟',
                                              onYesTap: (bCtx) {
                                                bCtx.pop();
                                                context.pop();
                                                context.read<HomeBloc>().add(DeleteProduct());
                                              },
                                            );
                                          } catch (_) {}
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              } catch (_) {}
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing16, vertical: sizeConstants.spacing8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
                                color: Theme.of(context).primaryColor.withAlpha(200),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'فیلتر ها',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhiteColor),
                                  ),
                                  Icon(Icons.filter_alt_rounded, color: kWhiteColor),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Selector<HomeProvider, int>(
                            selector: (context, homeProvider) => homeProvider.homeBuilderLayout,
                            builder: (context, layout, child) {
                              return RefreshIndicator(
                                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                                onRefresh: () async {
                                  try {
                                    context.read<HomeBloc>().add(FetchProducts());
                                  } catch (_) {}
                                },
                                child: CustomAlignedGridView(
                                  itemBuilder: (builderContext, index) {
                                    ProductModel product = products[index];
                                    return GestureDetector(
                                      onTap: () {
                                        try {
                                          BottomSheetHelper.showBottomSheet(
                                            context: builderContext,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                BottomSheetItem(
                                                  title: 'ویرایش',
                                                  color: kGreenColor,
                                                  icon: Icons.edit_note_rounded,
                                                  onTap: () {
                                                    try {
                                                      ToastPackage.showSimpleToast(context: context, message: 'به زودی...');
                                                      context.pop();
                                                    } catch (_) {}
                                                  },
                                                ),
                                                BottomSheetItem(
                                                  title: 'حذف',
                                                  color: kRedColor,
                                                  icon: Icons.delete,
                                                  onTap: () {
                                                    try {
                                                      PopupHelpers.showYesOrNoDialog(
                                                        context: context,
                                                        title: '"${product.name}" را حذف میکنید؟',
                                                        onYesTap: (bCtx) {
                                                          bCtx.pop();
                                                          builderContext.pop();
                                                          context.read<HomeBloc>().add(DeleteProduct(id: product.id));
                                                        },
                                                      );
                                                    } catch (_) {}
                                                  },
                                                ),
                                                BottomSheetItem(
                                                  title: 'جزئیات',
                                                  color: kBlueColor,
                                                  icon: Icons.info_outline_rounded,
                                                  bottom: true,
                                                  onTap: () {
                                                    try {
                                                      context.pop();
                                                      context.push(
                                                        ProductDetailsScreen.id,
                                                        extra: {'product_id': product.id, 'product_name': product.name},
                                                      );
                                                    } catch (_) {}
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        } catch (_) {}
                                      },
                                      child: HomeProductModelCard(
                                        name: product.name,
                                        total: product.total,
                                        color: context.read<AppProvider>().getStableColor(index),
                                      ),
                                    );
                                  },
                                  length: products.length,
                                  crossAxisCount: layout,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                return Expanded(
                  child: Center(
                    child: TryAgainBtn(
                      onTryAgain: () {
                        try {
                          context.read<HomeBloc>().add(FetchProducts());
                        } catch (_) {}
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
