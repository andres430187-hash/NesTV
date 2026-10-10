import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../theme/nesh_theme.dart';

class PlayerScreen extends StatefulWidget {
  final String streamUrl;
  final String title;
  const PlayerScreen({super.key, required this.streamUrl, this.title = 'Nesh'});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final VideoPlayerController _videoController;
  ChewieController? _chewieController;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      _videoController = VideoPlayerController.networkUrl(
          Uri.parse(widget.streamUrl));
      await _videoController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowedScreenSleep: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: NeshColors.neon,
          handleColor: NeshColors.neon,
          bufferedColor: NeshColors.neon.withOpacity(0.3),
          backgroundColor: NeshColors.surfaceAlt,
        ),
        placeholder: const Center(
          child: CircularProgressIndicator(color: NeshColors.neon),
        ),
      );
      if (mounted) setState(() {});
    } catch (e) {
      setState(() => _error = 'No se pudo reproducir el stream.');
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeshColors.black,
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: _error != null
            ? Text(_error!,
                style: const TextStyle(color: NeshColors.error))
            : _chewieController != null
                ? Chewie(controller: _chewieController!)
                : const CircularProgressIndicator(color: NeshColors.neon),
      ),
    );
  }
}
