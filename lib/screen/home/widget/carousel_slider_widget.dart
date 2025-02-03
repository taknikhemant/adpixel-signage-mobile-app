import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:video_player/video_player.dart';

import '../models/device_templete_data_model.dart';

class CarouselSliderWidget extends StatelessWidget {
  final int? expandeFlex;
  final List<Carousal>? mediaItems;
  final CarouselSliderController? carouselController;
  const CarouselSliderWidget(
      {this.expandeFlex = 4,
      this.carouselController,
      required this.mediaItems,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: expandeFlex ?? 0,
      child: mediaItems == null || mediaItems!.isEmpty
          ? Center(
              child: Text(
                "No Data found",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.sp),
              ),
            )
          : CarouselSlider.builder(
              disableGesture: true,
              itemCount: mediaItems!.length,
              itemBuilder: (context, index, realIndex) {
                final mediaItem = mediaItems![index];
                return MediaWidget(mediaItem: mediaItem);
              },
              options: CarouselOptions(
                enableInfiniteScroll: true,
                autoPlay: mediaItems!.length > 1 ? true : false,
                viewportFraction: 1,
                disableCenter: true,
                // enlargeCenterPage: true,
                autoPlayInterval: const Duration(seconds: 10),
              ),
            ),
    );
  }
}

class MediaWidget extends StatefulWidget {
  final Carousal mediaItem;

  const MediaWidget({super.key, required this.mediaItem});

  @override
  State<MediaWidget> createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  VideoPlayerController? _videoController;
  @override
  void initState() {
    super.initState();
    if (widget.mediaItem.fileType == 'video') {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.mediaItem.file!))
            ..initialize().then((_) {
              setState(() {});
              _videoController?.setLooping(true);
              _videoController?.play();
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
    switch (widget.mediaItem.fileType) {
      case 'Image':
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
      case 'gif':
        return Image.network(
          widget.mediaItem.file!,
          fit: BoxFit.fill,
          width: double.infinity,
        );
      default:
        return const Center(child: Text('Unsupported media type'));
    }
  }
}
