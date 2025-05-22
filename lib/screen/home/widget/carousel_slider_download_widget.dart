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
  final List<Carousal>? mediaItems;

  const CarouselSliderDownloadWidget({
    this.expandeFlex = 4,
    this.autoScrollSingleFile = true,
    required this.mediaItems,
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

  // final downloader = FileDownloader();

  @override
  void initState() {
    super.initState();
    log("message=>${widget.mediaItems!.map((e) => "file:${e.file}, fileType:${e.fileType}").toList()}",
        name: "CarouselSliderDownloadWidget");
    Future.delayed(Duration.zero, () async {
      List<Carousal> savedFils =
          await homeController.downloader.loadFromSharedPrefs();
      List<Carousal> mediaItems = widget.mediaItems!;

      // Find and download items not in savedFils
      for (var item in mediaItems) {
        bool isSaved = savedFils.any((saved) => saved.file == item.file);
        if (!isSaved) {
          await homeController.downloader.downloadFile(item);
          log("message=>${item.localFile}", name: "download items");
        }
      }

      // Remove saved files that are not in mediaItems or not from the network
      for (var saved in savedFils) {
        bool existsInMedia = mediaItems.any((item) => item.file == saved.file);
        bool isNetworkFile = saved.file!.startsWith('http');
        if (!existsInMedia || !isNetworkFile) {
          await homeController.downloader.removeFile(saved);
          log("message=>${saved.localFile}", name: "Remove saved files");
        }
      }
      // Re-fetch updated local file list AFTER all downloads/removals
      final updatedSaved =
          await homeController.downloader.loadFromSharedPrefs();

      homeController.mediaItems.value = updatedSaved;
      homeController.mediaItems.refresh();
      homeController.isDownloading.value = false;
      log("message=>$updatedSaved", name: "init saved files");
    });
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
              widget.mediaItems!.length > 1);

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
                ? Center(
                    child: Text(
                      "No Data found",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 50.sp),
                    ),
                  )
                : Obx(() {
                    return CarouselSlider.builder(
                      carouselController: carouselController,
                      itemCount: homeController.mediaItems.value!.length,
                      itemBuilder: (context, index, realIndex) {
                        final mediaItem =
                            homeController.mediaItems.value![index];
                        return MediaWidget(
                          mediaItem: mediaItem,
                          onVideoStart: _onVideoStart,
                          onVideoEnd: _onVideoEnd,
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
