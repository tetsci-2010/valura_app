import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/constants/images_paths.dart';
import 'package:valura/features/data/blocs/create_item_bloc/create_item_bloc.dart';
import 'package:valura/features/data/blocs/home_bloc/home_bloc.dart';
import 'package:valura/packages/toast_package/toast_package.dart';
import 'package:valura/utils/my_media_query.dart';
import 'package:valura/utils/size_constant.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/home_screen';
  static const String name = 'home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomAppbar(
            child: Row(
              children: [
                CircleAvatar(
                  maxRadius: sizeConstants.avatarSmall,
                  minRadius: sizeConstants.avatarSmall,
                  backgroundImage: AssetImage(ImagesPaths.valuraTextJpg),
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
                      'به والورا خوش آمدی!',
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
                ToastPackage.showSimpleToast(context: context, message: state.errorMessage);
              }
            },
            builder: (context, state) {
              if (state is FetchingProducts) {
                return Expanded(
                  child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
                );
              } else if (state is FetchProductsSuccess) {
                return Expanded(
                  child: Column(
                    children: [],
                  ),
                );
              } else {
                return Expanded(
                  child: Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(1000),
                      onTap: () {
                        try {
                        } catch (_) {}
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          border: Border.all(),
                        ),
                        child: Icon(Icons.refresh_rounded),
                      ),
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

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key, this.child, this.title});
  final Widget? child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getMediaQueryWidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(sizeConstants.radiusLarge),
          bottomRight: Radius.circular(sizeConstants.radiusLarge),
        ),
        color: Theme.of(context).primaryColor,
      ),
      padding: EdgeInsets.fromLTRB(
        sizeConstants.spacing16,
        ScreenUtil().statusBarHeight,
        sizeConstants.spacing16,
        sizeConstants.spacing16,
      ),
      child: title == null
          ? child ?? SizedBox.fromSize(size: Size.zero)
          : Center(
              child: Text(
                title!,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: kWhiteColor),
              ),
            ),
    );
  }
}
