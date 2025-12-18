import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/features/data/blocs/items_list_bloc/items_list_bloc.dart';
import 'package:valura/features/data/enums/sort.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/data/providers/items_list_provider.dart';
import 'package:valura/features/screens/main_screens/add_item_screen/widgets/item_part_card.dart';
import 'package:valura/features/screens/main_screens/edit_item_screen/edit_item_screen.dart';
import 'package:valura/helpers/bottom_sheet_helper.dart';
import 'package:valura/helpers/popup_helpers.dart';
import 'package:valura/packages/sqflite_package/sqflite_codes.dart';
import 'package:valura/packages/toast_package/toast_package.dart';
import 'package:valura/utils/dependency_injection.dart';
import 'package:valura/utils/size_constant.dart';
import 'package:valura/widgets/bottom_sheet_item.dart';
import 'package:valura/widgets/custom_aligned_grid_view.dart';
import 'package:valura/widgets/custom_appbar.dart';
import 'package:valura/widgets/loading_cover.dart';
import 'package:valura/widgets/try_again_btn.dart';

class ItemsScreen extends StatefulWidget {
  static const String id = '/items_screen';
  static const String name = 'items_screen';
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  void initState() {
    super.initState();
    try {
      context.read<ItemsListBloc>().add(FetchItemsList());
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomAppbar(title: 'لیست اجناس'),
          BlocBuilder<ItemsListBloc, ItemsListState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing16, vertical: sizeConstants.spacing8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
                  onTap: state is FetchItemsListSuccess
                      ? () {
                          try {
                            BottomSheetHelper.showBottomSheet(
                              context: context,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  BottomSheetItem(
                                    title: 'ترتیب لیست',
                                    color: kBlueColor,
                                    icon: ItemsListBloc.sort == Sort.ascending ? CupertinoIcons.sort_down : CupertinoIcons.sort_up,
                                    onTap: () {
                                      try {
                                        context.pop();
                                        if (ItemsListBloc.sort == Sort.ascending) {
                                          context.read<ItemsListBloc>().add(FetchItemsList(sort: Sort.descending));
                                        } else {
                                          context.read<ItemsListBloc>().add(FetchItemsList(sort: Sort.ascending));
                                        }
                                      } catch (_) {}
                                    },
                                  ),
                                  // BottomSheetItem(
                                  //   title: 'تغییر چینش',
                                  //   color: kGreenColor,
                                  //   icon: CupertinoIcons.list_bullet_below_rectangle,
                                  //   onTap: () {
                                  //     try {
                                  //       context.read<ItemsListProvider>().toggleLayout();
                                  //       context.pop();
                                  //     } catch (_) {}
                                  //   },
                                  // ),
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
                                            context.read<ItemsListBloc>().add(DeleteItem());
                                          },
                                        );
                                      } catch (_) {}
                                    },
                                  ),
                                ],
                              ),
                            );
                          } catch (_) {}
                        }
                      : () {},
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
              );
            },
          ),
          BlocConsumer<ItemsListBloc, ItemsListState>(
            listener: (context, state) {
              if (state is FetchItemsListFailure) {
                ToastPackage.showSimpleToast(context: context, message: getErrorMessage(state.errorMessage));
              }
            },
            builder: (context, state) {
              if (state is FetchingItemsList) {
                return Expanded(
                  child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)),
                );
              } else if (state is FetchItemsListSuccess) {
                List<ItemModel> items = state.items;
                return Expanded(
                  child: items.isNotEmpty
                      ? CustomAlignedGridView(
                          paddings: EdgeInsets.symmetric(horizontal: sizeConstants.spacing12),
                          itemBuilder: (builderContext, index) {
                            ItemModel item = items[index];
                            return ItemPartCard(
                              item: item,
                              onDeleteTap: (context) {
                                try {
                                  PopupHelpers.showYesOrNoDialog(
                                    context: context,
                                    title: 'آیتم "${item.name}" را حذف میکنید؟',
                                    onYesTap: (bCtx) {
                                      di<ItemsListBloc>().add(DeleteItem(id: item.id));
                                      bCtx.pop();
                                    },
                                  );
                                } catch (_) {}
                              },
                              onEditTap: (context) {
                                try {
                                  context.push(EditItemScreen.id, extra: {'item_model': item, 'route': ItemsScreen.id});
                                } catch (_) {}
                              },
                            );
                          },
                          length: items.length,
                          crossAxisCount: 1,
                        )
                      : Center(
                          child: Text('هیچ آیتمی وجود ندارد.'),
                        ),
                );
              } else {
                return Expanded(
                  child: Center(
                    child: TryAgainBtn(
                      onTryAgain: () {
                        try {
                          context.read<ItemsListBloc>().add(FetchItemsList());
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
