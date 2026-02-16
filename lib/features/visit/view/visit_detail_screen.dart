import 'package:archiz_staging_admin/common/components/app-bar/custom_appbar.dart';
import 'package:archiz_staging_admin/common/components/card/custom_card.dart';
import 'package:archiz_staging_admin/common/components/custom_loader/custom_loader.dart';
import 'package:archiz_staging_admin/common/components/dialog/warning_dialog.dart';
import 'package:archiz_staging_admin/common/components/divider/custom_divider.dart';
import 'package:archiz_staging_admin/common/components/text/text_icon.dart';
import 'package:archiz_staging_admin/core/helper/date_converter.dart';
import 'package:archiz_staging_admin/core/helper/string_format_helper.dart';
import 'package:archiz_staging_admin/core/route/route.dart';
import 'package:archiz_staging_admin/core/service/api_service.dart';
import 'package:archiz_staging_admin/core/service/location_manager_service.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/images.dart';
import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:archiz_staging_admin/core/utils/style.dart';
import 'package:archiz_staging_admin/features/visit/view/add_review_visit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controller/visit_controller.dart';
import '../repo/visit_repo.dart';

class VisitDetailsScreen extends StatefulWidget {
  const VisitDetailsScreen({super.key, required this.id});

  final String id;

  @override
  State<VisitDetailsScreen> createState() => _VisitDetailsScreenState();
}

class _VisitDetailsScreenState extends State<VisitDetailsScreen> {
  bool isTravelStarted = false;
  bool isMeetingStarted = false;
  String travelButtonText = "Start Travel";
  String status = "1";
  StringBuffer mapBuffer = StringBuffer();
  var locationTrack;
  double latitude = 0.0, longitude = 0.0;
  String userId = "";
  String _statusMessage = "Service not started";
  bool _isLoading = false;

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(VisitRepo(apiClient: Get.find()));
    final controller = Get.put(VisitController(visitRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadVisitDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.visitDetails.tr,
        isShowActionBtn: true,
        isShowActionBtnTwo: true,
        actionWidget: IconButton(
          onPressed: () {
            // Get.toNamed(RouteHelper.updateTicketScreen, arguments: widget.id);
          },
          icon: const Icon(Icons.edit, size: 20),
        ),
        actionWidgetTwo: IconButton(
          onPressed: () {
            const WarningAlertDialog().warningAlertDialog(
              context,
              () {
                Get.back();
                Get.find<VisitController>().deleteVisit(widget.id);
                Navigator.pop(context);
              },
              title: LocalStrings.deleteVisit.tr,
              subTitle: LocalStrings.deleteVisitWarningMSg.tr,
              image: MyImages.exclamationImage,
            );
          },
          icon: const Icon(Icons.delete, size: 20),
        ),
      ),
      body: GetBuilder<VisitController>(
        builder: (controller) {
          return controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    await controller.loadVisitDetails(widget.id);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.space12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                // '#${controller.ticketDetailsModel.data?.id} - ${controller.ticketDetailsModel.data?.name}',
                                '${controller.visitDetailsModel.data?.contactName}',
                                style: mediumLarge,
                              ),
                              // Text(
                              //   controller.ticketDetailsModel.data?.statusName
                              //       ?.tr.capitalize ??
                              //       '',
                              //   style: mediumDefault.copyWith(
                              //       color: ColorResources.ticketStatusColor(
                              //           controller.ticketDetailsModel.data
                              //               ?.status ??
                              //               '')),
                              // )
                            ],
                          ),
                          const SizedBox(height: Dimensions.space10),
                          CustomCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocalStrings.contact.tr,
                                  style: lightSmall,
                                ),
                                Text(
                                  '${controller.visitDetailsModel.data?.contactName ?? ''} (${controller.visitDetailsModel.data?.department ?? ''})',
                                  style: regularDefault,
                                ),
                                const CustomDivider(space: Dimensions.space10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      LocalStrings.department.tr,
                                      style: lightSmall,
                                    ),
                                    // Text(LocalStrings.service.tr,
                                    //     style: lightSmall),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller
                                              .visitDetailsModel
                                              .data
                                              ?.department ??
                                          '-',
                                      style: regularDefault,
                                    ),
                                    // Text(
                                    //     controller.ticketDetailsModel.data
                                    //         ?.serviceName ??
                                    //         '-',
                                    //     style: regularDefault),
                                  ],
                                ),
                                const CustomDivider(space: Dimensions.space10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      LocalStrings.createdDate.tr,
                                      style: lightSmall,
                                    ),
                                    Text(
                                      LocalStrings.createdTime.tr,
                                      style: lightSmall,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateConverter.formatValidityDate(
                                        controller
                                                .visitDetailsModel
                                                .data!
                                                .createDate ??
                                            '',
                                      ),
                                      style: regularDefault,
                                    ),

                                    Text(
                                        DateConverter.formatValidityTime(
                                          controller
                                              .visitDetailsModel
                                              .data!
                                              .createDate ??
                                              '',
                                        ),
                                    style: regularDefault),
                                  ],
                                ),
                                const CustomDivider(space: Dimensions.space10),
                                Text(
                                  LocalStrings.startAddress.tr,
                                  style: lightSmall,
                                ),
                                Text(
                                  Converter.parseHtmlString(
                                    controller
                                            .visitDetailsModel
                                            .data
                                            ?.startAddress ??
                                        '-',
                                  ),
                                  maxLines: 2,
                                  style: regularDefault,
                                ),

                                const CustomDivider(space: Dimensions.space10),
                                Text(
                                  LocalStrings.stopAddress.tr,
                                  style: lightSmall,
                                ),
                                Text(
                                  Converter.parseHtmlString(
                                    controller
                                            .visitDetailsModel
                                            .data
                                            ?.stopAddress ??
                                        '-',
                                  ),
                                  maxLines: 2,
                                  style: regularDefault,
                                ),
                                const CustomDivider(space: Dimensions.space10),
                                Text(
                                  LocalStrings.purpose.tr,
                                  style: lightSmall,
                                ),
                                Text(
                                  Converter.parseHtmlString(
                                    controller
                                            .visitDetailsModel
                                            .data
                                            ?.purpose ??
                                        '-',
                                  ),
                                  maxLines: 2,
                                  style: regularDefault,
                                ),
                              ],
                            ),
                          ),
                          // Add the buttons in two rows
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.space0,
                              vertical: Dimensions.space10,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: isTravelStarted
                                              ? ColorResources.colorRed
                                              : Theme.of(context).cardColor,
                                          border: Border.all(
                                            color:
                                                ColorResources.getTextFieldDisableBorder(),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.space8,
                                          ),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              Dimensions.space8,
                                            ),
                                            onTap: isMeetingStarted
                                                ? null
                                                : () {
                                                    setState(() async {
                                                      if (isTravelStarted) {
                                                        isTravelStarted = false;
                                                        _stopLocationService();
                                                      } else {
                                                       if(await checkNotificationPermission()) print(
                                                         "Notif.. Required permissions granted",
                                                       );
                                                       else print(
                                                         "Notif.. Required permissions not granted",
                                                       );
                                                        if (!await checkAllPermissionsGranted()) {
                                                          print("Loc.. Required permissions not granted");
                                                          // Show alert or navigate to settings
                                                          requestAllPermissions();
                                                        } else {
                                                          print("Loc...All permissions granted",
                                                          );
                                                          isTravelStarted =
                                                              true;
                                                          isMeetingStarted =
                                                              false;
                                                          _startLocationService();
                                                        }
                                                      }
                                                    });
                                                  },
                                            child: Center(
                                              child: Text(
                                                isTravelStarted
                                                    ? 'Stop Travel'
                                                    : 'Start Travel',
                                                style: regularDefault.copyWith(
                                                  color: isTravelStarted
                                                      ? Theme.of(context).colorScheme.onPrimary // For text on colored button
                                                      : (isMeetingStarted
                                                      ? Colors.grey
                                                      : Theme.of(context).textTheme.bodyMedium!.color),
                                                  // color: isTravelStarted
                                                  //     ? ColorResources
                                                  //           .colorWhite
                                                  //     : (isMeetingStarted
                                                  //           ? Colors.grey
                                                  //           : ColorResources.getTextColor()),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: isMeetingStarted
                                              ? ColorResources.colorRed
                                              : Theme.of(context).cardColor,
                                          border: Border.all(
                                            color:
                                                ColorResources.getTextFieldDisableBorder(),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.space8,
                                          ),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              Dimensions.space8,
                                            ),
                                            onTap: isTravelStarted
                                                ? null
                                                : () {
                                                    setState(() {
                                                      if (isMeetingStarted) {
                                                        isMeetingStarted =
                                                            false;
                                                      } else {
                                                        isMeetingStarted = true;
                                                        isTravelStarted = false;
                                                      }
                                                    });
                                                  },
                                            child: Center(
                                              child: Text(
                                                isMeetingStarted
                                                    ? 'Stop Meeting'
                                                    : 'Start Meeting',
                                                style: regularDefault.copyWith(
                                                  // color: isMeetingStarted
                                                  //     ? ColorResources
                                                  //           .colorWhite
                                                  //     : (isTravelStarted
                                                  //           ? Colors.grey
                                                  //           : ColorResources.getTextColor()),
                                                  color: isMeetingStarted
                                                      ? Theme.of(context).colorScheme.onPrimary // For text on colored button
                                                      : (isTravelStarted
                                                      ? Colors.grey
                                                      : Theme.of(context).textTheme.bodyMedium!.color),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          border: Border.all(
                                            color:
                                                ColorResources.getTextFieldDisableBorder(),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.space8,
                                          ),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              Dimensions.space8,
                                            ),
                                            onTap:
                                                (isTravelStarted ||
                                                    isMeetingStarted)
                                                ? null
                                                : () {
                                                    // End Travel action
                                                  },
                                            child: Center(
                                              child: Text(
                                                'End Travel',
                                                style: regularDefault.copyWith(
                                                  color:
                                                      (isTravelStarted ||
                                                          isMeetingStarted)
                                                      ? Colors.grey
                                                      : ColorResources.getTextColor(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: ColorResources.primaryColor,
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.space8,
                                          ),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              Dimensions.space8,
                                            ),
                                            onTap: () {
                                              print("Review button tapped!");
                                              try {
                                                // Try direct navigation first
                                                Get.to(
                                                  () =>
                                                      const AddReviewVisitScreen(),
                                                );
                                              } catch (e) {
                                                print(
                                                  "Direct navigation error: $e",
                                                );
                                                try {
                                                  // Fallback to named route
                                                  Get.toNamed(
                                                    RouteHelper
                                                        .addReviewVisitScreen,
                                                  );
                                                } catch (e2) {
                                                  print(
                                                    "Named route error: $e2",
                                                  );
                                                }
                                              }
                                            },
                                            child: Center(
                                              child: Text(
                                                'Review',
                                                style: regularDefault.copyWith(
                                                  color:
                                                      ColorResources.colorWhite,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  /// Start the location service
  Future<void> _startLocationService() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Starting location service...";
    });

    try {
      // Call the static method - equivalent to your Java call
      await LocationServiceManager.startLocationService();
      setState(() {
        _isLoading = false;
        _statusMessage = "Location service started successfully";
      });
      _showSnackBar("Location service started", Colors.green);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "Failed to start service: $e";
      });
      _showSnackBar("Failed to start service", Colors.red);
    }
  }

  /// Stop the location service
  Future<void> _stopLocationService() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Stopping location service...";
    });

    try {
      // Call the static method - equivalent to your Java call
      await LocationServiceManager.stopLocationService();

      setState(() {
        _isLoading = false;
        _statusMessage = "Location service stopped successfully";
      });

      _showSnackBar("Location service stopped", Colors.orange);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "Failed to stop service: $e";
      });

      _showSnackBar("Failed to stop service", Colors.red);
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

Future<bool> requestAllPermissions() async {
  final location = await Permission.location.request();
  final background = await Permission.locationAlways.request();
  // final notification = await Permission.notification.request();

  if (location.isGranted && background.isGranted) {
    return true;
  }

  if (location.isPermanentlyDenied ||
      background.isPermanentlyDenied) {
    await openAppSettings();
  }

  return false;
}

Future<bool> checkAllPermissionsGranted() async {
  final locationStatus = await Permission.location.status;
  final backgroundStatus = await Permission.locationAlways.status;
  return locationStatus.isGranted &&
      backgroundStatus.isGranted ;
}

// Check Notification Permission (especially for Android 13+)
Future<bool> checkNotificationPermission() async {
  final status = await Permission.notification.status;
  if (status.isGranted) {
    return true;
  } else {
    final result = await Permission.notification.request();
    return result.isGranted;
  }
}

Future<bool> isGpsEnabled() async {
  Location location = Location();
  return await location.serviceEnabled() || await location.requestService();
}

Future<void> promptEnableGPS(BuildContext context) async {
  bool gpsEnabled = await isGpsEnabled();
  if (!gpsEnabled) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Enable GPS'),
        content: Text(
          'Your GPS seems to be disabled. Do you want to enable it?',
        ),
        actions: [
          TextButton(
            child: Text('Yes'),
            onPressed: () async {
              await Location().requestService();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

// Optional: Get Android SDK version
Future<int> _getAndroidSdkVersion() async {
  const platform = MethodChannel('device_info');
  try {
    final version = await platform.invokeMethod<int>('getAndroidSdk');
    return version ?? 33; // fallback
  } catch (e) {
    return 33;
  }
}

Future<void> updateStatus(
  String userId,
  String companyId,
  String visitId,
  String status,
  double lat,
  double lon,
  String vId,
) async {}
