import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/constants/images_paths.dart';
import 'package:valura/features/data/blocs/backup_bloc/backup_bloc.dart';
import 'package:valura/features/data/models/backup_model.dart';
import 'package:valura/gen/fonts.gen.dart';
import 'package:valura/helpers/popup_helpers.dart';
import 'package:valura/packages/restart_app_package/restart_app_package.dart';
import 'package:valura/packages/sqflite_package/sqflite_codes.dart';
import 'package:valura/packages/toast_package/toast_package.dart';
import 'package:valura/utils/my_media_query.dart';
import 'package:valura/utils/size_constant.dart';
import 'package:valura/widgets/custom_appbar.dart';
import 'package:valura/widgets/try_again_btn.dart';
import 'package:restart_app/restart_app.dart';

class BackupScreen extends StatefulWidget {
  static const String id = '/backup_screen';
  static const String name = 'backup_screen';
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  dynamic bkListState;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(title: 'پشتیبان گیری', showBackBtn: true),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: 'image',
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: sizeConstants.spacing16, vertical: sizeConstants.spacing12),
                    width: getMediaQueryWidth(context),
                    height: 240.r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
                      image: DecorationImage(image: AssetImage(ImagesPaths.backupJpg), fit: BoxFit.cover),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0),
                          spreadRadius: 3,
                          blurRadius: 5,
                          color: Theme.of(context).shadowColor.withAlpha(30),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: sizeConstants.spacing8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing16),
                  child: Text('از اطلاعات خود محافظت کنید — یک نسخه پشتیبان تهیه کنید.', style: Theme.of(context).textTheme.bodyLarge),
                ),
                SizedBox(height: sizeConstants.spacing4),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing16),
                  child: Text(
                    'با تهیه نسخه پشتیبان می‌توانید در صورت تغییر دستگاه، حذف برنامه یا بروز مشکل، اطلاعات خود را بازیابی کنید.',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).textTheme.labelLarge?.color),
                  ),
                ),
                SizedBox(height: sizeConstants.spacing24),
                BlocConsumer<BackupBloc, BackupState>(
                  listener: (context, state) {
                    if (state is CreateBackupFailure) {
                      ToastPackage.showSimpleToast(context: context, message: getErrorMessage(state.errorMessage));
                    } else if (state is CreateBackupSuccess) {
                      ToastPackage.showSimpleToast(context: context, message: 'پشتیبان گیری انجام شد');
                    } else if (state is FetchingBackups) {
                      bkListState = state;
                    } else if (state is FetchBackupsFailure) {
                      ToastPackage.showSimpleToast(context: context, message: getErrorMessage(state.errorMessage));
                    } else if (state is FetchBackupsSuccess) {
                      bkListState = state;
                    } else if (state is RestoreBackupSuccess) {
                      RestartAppPackage.restartApp();
                    } else if (state is RestoreBackupFailure) {
                      ToastPackage.showSimpleToast(context: context, message: getErrorMessage(state.errorMessage));
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: getMediaQueryWidth(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: getMediaQueryWidth(context, 0.8),
                            height: 50.r,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: kWhiteColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sizeConstants.radiusMedium)),
                              ),
                              onPressed: () {
                                try {
                                  PopupHelpers.showWarningYesOrNoDialog(
                                    context: context,
                                    icon: Icons.cloud_sync_rounded,
                                    title: 'پشتیبان گیری اطلاعات را شروع میکنید؟',
                                    onYesTap: (bCtx) {
                                      context.read<BackupBloc>().add(CreateBackup());
                                      bCtx.pop();
                                    },
                                  );
                                } catch (_) {}
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  state is CreatingBackup ? CupertinoActivityIndicator(color: kWhiteColor) : Icon(Icons.backup_outlined),
                                  SizedBox(width: sizeConstants.spacing12),
                                  Text(
                                    'پشتیبان گیری اطلاعات',
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(color: kWhiteColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: sizeConstants.spacing8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
                            child: SizedBox(
                              height: 50.r,
                              child: DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  dashPattern: [10, 5],
                                  strokeWidth: 2,
                                  radius: Radius.circular(16),
                                  color: Colors.indigo,
                                  padding: EdgeInsets.all(1),
                                ),
                                child: SizedBox(
                                  width: getMediaQueryWidth(context, 0.8),
                                  height: 50.r,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kBlueColor.withAlpha(70),
                                      foregroundColor: kWhiteColor,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sizeConstants.radiusMedium)),
                                    ),
                                    onPressed: () {
                                      try {
                                        PopupHelpers.showWarningYesOrNoDialog(
                                          context: context,
                                          description: 'در صورت راه اندازی بک آپ، اطلاعات فعلی از بین خواهند رفت.',
                                          title: 'بک آپ جدید راه اندازی شود؟',
                                          onYesTap: (bCtx) {
                                            context.read<BackupBloc>().add(RestoreBackup());
                                            bCtx.pop();
                                          },
                                        );
                                      } catch (_) {}
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.screen_search_desktop_outlined, color: Theme.of(context).primaryColor),
                                        SizedBox(width: sizeConstants.spacing12),
                                        Text(
                                          'راه اندازی بک آپ',
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: sizeConstants.spacing16),
                Expanded(
                  child: Container(
                    width: getMediaQueryWidth(context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(sizeConstants.radiusLarge),
                        topRight: Radius.circular(sizeConstants.radiusLarge),
                      ),
                      color: Theme.of(context).cardColor,
                    ),
                    child: BlocBuilder<BackupBloc, BackupState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                sizeConstants.spacing16,
                                sizeConstants.spacing12,
                                sizeConstants.spacing16,
                                sizeConstants.spacing8,
                              ),
                              child: Text('لیست پشتیبان گیری'),
                            ),
                            Expanded(
                              child: true
                                  ? Center(
                                      child: Text('به زودی...'),
                                    )
                                  : bkListState is FetchingBackups
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : bkListState is FetchBackupsSuccess
                                  ? RefreshIndicator(
                                      onRefresh: () async {
                                        try {
                                          context.read<BackupBloc>().add(FetchBackups());
                                        } catch (_) {}
                                      },
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing16, vertical: sizeConstants.spacing12),
                                        itemCount: bkListState.backups.length,
                                        itemBuilder: (context, index) {
                                          BackupModel backup = bkListState.backups[index];
                                          return Container(
                                            margin: EdgeInsets.only(bottom: sizeConstants.spacing12),
                                            padding: EdgeInsets.fromLTRB(
                                              sizeConstants.spacing12,
                                              sizeConstants.spacing8,
                                              sizeConstants.spacing16,
                                              sizeConstants.spacing8,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
                                              border: Border.all(color: Theme.of(context).textTheme.labelLarge?.color ?? kBlackColor),
                                            ),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.more_vert_rounded),
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        backup.name,
                                                        style:
                                                            Theme.of(
                                                              context,
                                                            ).textTheme.bodyMedium!.copyWith(
                                                              color: Theme.of(context).textTheme.titleMedium?.color,
                                                              fontFamily: FontFamily.poppins,
                                                            ),
                                                        maxLines: 1,
                                                        textAlign: TextAlign.end,
                                                      ),
                                                      Text(
                                                        backup.path,
                                                        maxLines: 2,
                                                        textAlign: TextAlign.end,
                                                        style:
                                                            Theme.of(
                                                              context,
                                                            ).textTheme.bodySmall!.copyWith(
                                                              color: Theme.of(context).textTheme.labelLarge?.color,
                                                              fontFamily: FontFamily.poppins,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: TryAgainBtn(
                                        onTryAgain: () {
                                          try {
                                            context.read<BackupBloc>().add(FetchBackups());
                                          } catch (_) {}
                                        },
                                      ),
                                    ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
