import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/constants/lists.dart';
import 'package:valura/features/data/blocs/home_bloc/home_bloc.dart';
import 'package:valura/features/data/providers/app_provider.dart';
import 'package:valura/utils/size_constant.dart';

class MainHomeScreen extends StatelessWidget {
  static const String id = '/main_home_screen';
  static const String name = 'main_home_scree';
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Selector<AppProvider, int>(
        selector: (context, appProvider) => appProvider.getSelectedScreen,
        builder: (context, selectedIndex, child) {
          return screens[selectedIndex];
        },
      ),
      bottomNavigationBar: Selector<AppProvider, int>(
        selector: (context, appProvider) => appProvider.getSelectedScreen,
        builder: (context, selectedIndex, child) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(maxHeight: 85.r, minHeight: 85.r),
              padding: EdgeInsets.fromLTRB(sizeConstants.spacing32, sizeConstants.spacing12, sizeConstants.spacing32, sizeConstants.spacing20),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(sizeConstants.radiusXLarge),
                  topRight: Radius.circular(sizeConstants.radiusXLarge),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 12,
                    spreadRadius: 5,
                    color: Theme.of(context).brightness == Brightness.light ? kBlackColor12 : kGreyColor800.withAlpha(70),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  homeNavBtns.length,
                  (index) => GestureDetector(
                    onTap: () {
                      try {
                        context.read<AppProvider>().updateSelectedScreen(index);
                        if (index == 1) {
                          context.read<HomeBloc>().add(FetchProducts());
                        }
                      } catch (_) {}
                    },
                    child: AnimatedContainer(
                      width: 55.r,
                      height: 65.r,
                      duration: Duration(milliseconds: 300),
                      // padding: EdgeInsets.all(selectedIndex == index ? sizeConstants.spacing16 : sizeConstants.spacing12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        color: selectedIndex == index ? Theme.of(context).primaryColor : null,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        homeNavBtns[index],
                        color: selectedIndex == index
                            ? kWhiteColor
                            : Theme.of(context).brightness == Brightness.light
                            ? kGreyColor400
                            : kGreyColor700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
