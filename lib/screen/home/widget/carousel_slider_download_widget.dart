import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controller/home_controller.dart';
import '../models/device_templete_data_model.dart';

class CarouselSliderDownloadWidget extends StatefulWidget {
  final int? expandeFlex;
  final bool? autoScrollSingleFile;
  final bool? showTextOnBottom;
  // final List<Carousal>? mediaItems;

  const CarouselSliderDownloadWidget({
    this.expandeFlex = 4,
    this.autoScrollSingleFile = true,
    this.showTextOnBottom = false,
    // required this.mediaItems,
    super.key,
  });

  @override
  State<CarouselSliderDownloadWidget> createState() =>
      _CarouselSliderDownloadWidgetState();
}

class _CarouselSliderDownloadWidgetState
    extends State<CarouselSliderDownloadWidget> {
  final homeController = Get.find<HomeController>();
  CarouselSliderController? carouselController = CarouselSliderController();

  bool _isInitFilesUpdating = false;

  @override
  void initState() {
    super.initState();

    log(
      "Carousel items => ${homeController.templateData.value!.data!.carousal!.map((e) => "file:${e.file}, fileType:${e.fileType}").toList()}",
      name: "CarouselSliderDownloadWidget",
    );
    // Listen to message changes

    onInitFilesUpdateFxn(); // First call on widget init
    homeController.socketService.carousalList.listen((carousals) async {
      if (carousals != null) {
        await onInitFilesUpdateFxn();
        log("Carousal updated: ${carousals.length} items",
            name: "from CarousalList.listen");
        // Perform any UI or data update here
      }
    });
  }

  Future<void> onInitFilesUpdateFxn() async {
    if (_isInitFilesUpdating) {
      log("Already running: onInitFilesUpdateFxn, skipping new call",
          name: "CarouselGuard");
      return;
    }

    _isInitFilesUpdating = true; // Set lock

    try {
      log("Started onInitFilesUpdateFxn", name: "CarouselSync");

      homeController.isDownloading.value = true;
      homeController.isDownloading.refresh();

      final allSavedFiles =
          await homeController.downloader.loadFromSharedPrefs();
      final mediaItems = homeController.templateData.value!.data!.carousal;

      if (mediaItems == null) {
        log("mediaItems is null", name: "CarouselSync");
        return;
      }

      final filesToDownload = mediaItems.where(
        (item) => !allSavedFiles.any((saved) => saved.file == item.file),
      );

      for (final item in filesToDownload) {
        await homeController.downloader.downloadFile(
          item,
          category: 'carousel',
        );
        log("Downloaded: ${item.file}", name: "CarouselDownload");
      }

      final filesToRemove = allSavedFiles.where((saved) {
        final notInMedia = !mediaItems.any((item) => item.file == saved.file);
        final isNetworkFile = saved.file?.startsWith('http') ?? false;
        final isCarousel = saved.category == 'carousel';
        return notInMedia && isNetworkFile && isCarousel;
      });

      for (final saved in filesToRemove) {
        await homeController.downloader.removeFile(saved);
        log("Removed: ${saved.localFile}", name: "CarouselCleanup");
      }

      final updatedSaved =
          await homeController.downloader.loadFromSharedPrefs();

      homeController.mediaItems.value =
          updatedSaved.where((item) => item.category == 'carousel').toList();

      homeController.isDownloading.value = false;
      homeController.mediaItems.refresh();

      log("CarouselSyncDone: ${updatedSaved.map((e) => "{sequence:${e.sequence}, localFile:${e.localFile}, category:${e.category}, file:${e.file}}").toList()}");
    } catch (e, stack) {
      log("Error in onInitFilesUpdateFxn: $e\n$stack", name: "CarouselSync");
    } finally {
      _isInitFilesUpdating = false; // Release lock
    }
  }

  void _onVideoStart() {
    homeController.isTemplateVideoPlaying.value = true;
  }

  void _onVideoEnd() {
    homeController.isTemplateVideoPlaying.value = false;
    // Move to next slide when video completes
    if (carouselController != null) {
      carouselController!.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Disable autoPlay when a template video is playing
      final shouldAutoPlay = !homeController.isTemplateVideoPlaying.value &&
          (widget.autoScrollSingleFile == true ||
              homeController.templateData.value!.data!.carousal!.length > 1);

      return Expanded(
        flex: widget.expandeFlex ?? 0,
        child: homeController.isDownloading.value
            ? const Center(
                child: Text(
                  'Downloading...',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              )
            : homeController.mediaItems.value == null ||
                    homeController.mediaItems.value!.isEmpty
                ? Image.asset(
                    "assets/signage_pixel_default_banner.jpg",
                    fit: BoxFit.fill,
                    width: Get.width,
                  )
                : Obx(() {
                    return CarouselSlider.builder(
                      carouselController: carouselController,
                      itemCount: homeController.mediaItems.value!.length,
                      itemBuilder: (context, index, realIndex) {
                        final mediaItem =
                            homeController.mediaItems.value![index];
                        return Column(
                          children: [
                            Expanded(
                              child: MediaWidget(
                                mediaItem: mediaItem,
                                onVideoStart: _onVideoStart,
                                onVideoEnd: _onVideoEnd,
                              ),
                            ),
                            mediaItem.dynamicFieldsValue == null
                                ? const SizedBox()
                                : Visibility(
                                    visible: widget.showTextOnBottom!,
                                    child: Container(
                                      width: Get.width,
                                      color: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 14.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ...mediaItem.dynamicFieldsValue!.map(
                                            (e) => Text(
                                              "${e.key} : ${e.value}",
                                              style: TextStyle(
                                                  fontSize: 50.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        );
                      },
                      options: CarouselOptions(
                        enableInfiniteScroll: true,
                        autoPlay: shouldAutoPlay,
                        // !homeController.isTemplateVideoPlaying.value &&
                        //     true,
                        // !homeController.isTemplateVideoPlaying.value &&
                        //         widget.autoScrollSingleFile == true
                        //     ? true
                        //     : (widget.mediaItems!.length > 1),
                        // autoPlay: !homeController.isTemplateVideoPlaying.value &&
                        //     (widget.mediaItems!.length > 1),
                        viewportFraction: 1,
                        disableCenter: true,
                        autoPlayInterval: const Duration(seconds: 10),
                      ),
                    );
                  }),
      );
    });
  }
}

class MediaWidget extends StatefulWidget {
  final Carousal mediaItem;
  final VoidCallback onVideoStart;
  final VoidCallback onVideoEnd;

  const MediaWidget({
    super.key,
    required this.mediaItem,
    required this.onVideoStart,
    required this.onVideoEnd,
  });

  @override
  State<MediaWidget> createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    log("message=>${widget.mediaItem.fileType!.toLowerCase()}",
        name: "file data");
    _loadMedia();
  }

  void _loadMedia() async {
    String fileType = widget.mediaItem.fileType!.toLowerCase();
    String? localFile = widget.mediaItem.localFile;

    if (fileType == 'video' && localFile != null) {
      _videoController = VideoPlayerController.file(File(localFile))
        ..initialize().then((_) {
          setState(() {});
          _videoController?.setLooping(false);
          _videoController?.play();
          widget.onVideoStart();
          _videoController?.addListener(_checkVideoCompletion);
        });
    }
  }

  void _checkVideoCompletion() {
    if (_videoController != null &&
        _videoController!.value.isInitialized &&
        _videoController!.value.position >= _videoController!.value.duration) {
      widget.onVideoEnd();
      _videoController?.removeListener(_checkVideoCompletion);
    }
  }

  @override
  void dispose() {
    _videoController?.removeListener(_checkVideoCompletion);
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? localFile = widget.mediaItem.localFile;
    if (localFile == null) {
      return const Center(child: Text('Media not available'));
    }

    switch (widget.mediaItem.fileType!.toLowerCase()) {
      case 'image':
      case 'gif':
        return Image.file(
          File(localFile),
          fit: BoxFit.fill,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.error, size: 50.r),
        );

      case 'video':
        return _videoController != null && _videoController!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              )
            : const Center(child: CircularProgressIndicator());

      default:
        return Center(
          child: Text('Unsupported media type ${widget.mediaItem.fileType}'),
        );
    }
  }
}
