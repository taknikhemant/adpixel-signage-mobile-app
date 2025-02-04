import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../models/device_templete_data_model.dart';

class CarouselSliderWidget extends StatefulWidget {
  final int? expandeFlex;
  final List<Carousal>? mediaItems;
  final CarouselSliderController? carouselController;

  const CarouselSliderWidget({
    this.expandeFlex = 4,
    this.carouselController,
    required this.mediaItems,
    super.key,
  });

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  bool _isVideoPlaying = false;

  void _onVideoStart() {
    setState(() {
      _isVideoPlaying = true;
    });
  }

  void _onVideoEnd() {
    setState(() {
      _isVideoPlaying = false;
    });
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
          : CarouselSlider.builder(
              carouselController: widget.carouselController,
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
                autoPlay: !_isVideoPlaying && (widget.mediaItems!.length > 1),
                viewportFraction: 1,
                disableCenter: true,
                autoPlayInterval: const Duration(seconds: 10),
              ),
            ),
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
    if (widget.mediaItem.fileType!.toLowerCase() == 'video') {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.mediaItem.file!))
            ..initialize().then((_) {
              setState(() {});
              _videoController?.setLooping(false); // Disable looping
              _videoController?.play();
              widget.onVideoStart();

              // Listen for video completion
              _videoController?.addListener(() {
                if (_videoController!.value.position >=
                    _videoController!.value.duration) {
                  widget.onVideoEnd();
                }
              });
            });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.mediaItem.fileType!.toLowerCase()) {
      case 'image':
      case 'gif':
        return Image.network(
          widget.mediaItem.file!,
          fit: BoxFit.fill,
          width: double.infinity,
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
