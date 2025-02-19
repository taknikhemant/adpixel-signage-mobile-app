import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../services/custom_cache_manager.dart';
import '../controller/home_controller.dart';
import '../models/device_templete_data_model.dart';

class CarouselSliderWidget extends StatefulWidget {
  final int? expandeFlex;
  final List<Carousal>? mediaItems;

  const CarouselSliderWidget({
    this.expandeFlex = 4,
    required this.mediaItems,
    super.key,
  });

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  final homeController = Get.find<HomeController>();
  CarouselSliderController? carouselController = CarouselSliderController();
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
    return Expanded(
      flex: widget.expandeFlex ?? 0,
      child: widget.mediaItems == null || widget.mediaItems!.isEmpty
          ? Center(
              child: Text(
                "No Data found",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.sp),
              ),
            )
          : Obx(() {
              return CarouselSlider.builder(
                carouselController: carouselController,
                itemCount: widget.mediaItems!.length,
                itemBuilder: (context, index, realIndex) {
                  final mediaItem = widget.mediaItems![index];
                  return MediaWidget(
                    mediaItem: mediaItem,
                    onVideoStart: _onVideoStart,
                    onVideoEnd: _onVideoEnd,
                  );
                },
                options: CarouselOptions(
                  enableInfiniteScroll: true,
                  autoPlay:
                      !homeController.isTemplateVideoPlaying.value && true,
                  // autoPlay: !homeController.isTemplateVideoPlaying.value &&
                  //     (widget.mediaItems!.length > 1),
                  viewportFraction: 1,
                  disableCenter: true,
                  autoPlayInterval: const Duration(seconds: 10),
                ),
              );
            }),
    );
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
    String fileUrl = widget.mediaItem.file!;

    if (fileType == 'video') {
      // Download and cache the video
      final file = await CustomCacheManager().getSingleFile(fileUrl);
      _videoController = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {});
          _videoController?.setLooping(false);
          _videoController?.play();
          widget.onVideoStart();

          // Listen for video completion
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
    switch (widget.mediaItem.fileType!.toLowerCase()) {
      case 'image':
      case 'gif':
        return CachedNetworkImage(
          imageUrl: widget.mediaItem.file!,
          fit: BoxFit.fill,
          width: double.infinity,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error, size: 50.r),
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
            child: Text('Unsupported media type ${widget.mediaItem.fileType}'));
    }
  }
}
