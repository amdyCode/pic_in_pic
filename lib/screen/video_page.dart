import 'package:flutter/material.dart';
import 'package:pic_in_pic/extentions/gap.dart';
import 'package:video_player/video_player.dart';

import '../widgets/hud.dart';
import '../widgets/video_action_button.dart';
import '../widgets/video_details.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/description_bottom_sheet.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool _isMinimized = false;
  Offset _offset = const Offset(20, 20);
  late Offset _bottomRightOffset;
  bool _inMoove = false;

  final GlobalKey<MaximisedVideoHudState> _hudKey =
      GlobalKey<MaximisedVideoHudState>();

  late VideoPlayerController _videoController;

  // Constants
  static const double _appPadding = 20.0;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  void _initializeVideoController() {
    _videoController =
        VideoPlayerController.asset("assets/videos/uncharted.mp4")
          ..initialize().then((_) {
            _videoController.play();
            setState(() {});
          });
  }

  void _toggleVideoSize() {
    setState(() {
      _isMinimized = !_isMinimized;
      _offset = _bottomRightOffset;
    });
  }

  void _toggleInMove() {
    setState(() {
      _inMoove = !_inMoove;
    });
  }

  void _rewind10Seconds() async {
    final currentPosition = await _videoController.position;
    if (currentPosition != null) {
      final newPosition = currentPosition - const Duration(seconds: 10);
      _videoController
          .seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
    }
  }

  void _forward10Seconds() async {
    final currentPosition = await _videoController.position;
    if (currentPosition != null) {
      final maxDuration = _videoController.value.duration;
      final newPosition = currentPosition + const Duration(seconds: 10);
      _videoController
          .seekTo(newPosition < maxDuration ? newPosition : maxDuration);
    }
  }

  void _snapToClosestCorner(Size screenSize, Size containerSize) {
    double dx = _offset.dx;
    double dy = _offset.dy;

    final corners = [
      Offset(_appPadding, MediaQuery.of(context).viewPadding.top),
      Offset(screenSize.width - _appPadding - containerSize.width,
          MediaQuery.of(context).viewPadding.top),
      Offset(
          _appPadding,
          screenSize.height -
              containerSize.height -
              MediaQuery.of(context).viewPadding.bottom),
      Offset(
          screenSize.width - _appPadding - containerSize.width,
          screenSize.height -
              containerSize.height -
              MediaQuery.of(context).viewPadding.bottom),
    ];

    final closestCorner = corners.reduce((a, b) {
      final distanceA = (a.dx - dx).abs() + (a.dy - dy).abs();
      final distanceB = (b.dx - dx).abs() + (b.dy - dy).abs();
      return distanceA < distanceB ? a : b;
    });

    setState(() {
      _offset = closestCorner;
    });
  }

  void _showDescriptionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, controller) => const DescriptionBottomSheet(
          title: "Le Footballeur Qui A Mis Fin À La Guerre Dans Son Pays",
          likes: "1,5 k",
          views: "56 983",
          date: "21 sept. 2025",
          description:
              "Il a marqué l’histoire de Chelsea à Munich... mais surtout, une phrase dans un vestiaire a fait taire les armes en Côte d'Ivoire.\nDans cette vidéo, je raconte comment Didier Drogba est passé de Didi à Abidjan au héros des grands soirs, et comment son message de 2005 puis le match à Bouaké en 2007 o...",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final minimizedSize = Size(screenSize.width - _appPadding * 7, 170);

    _bottomRightOffset = Offset(
        screenSize.width - _appPadding - minimizedSize.width,
        screenSize.height -
            minimizedSize.height -
            MediaQuery.of(context).viewPadding.bottom);

    return Stack(
      children: [
        Scaffold(
          body: _isMinimized
              ? const Center(
                  child: Text(
                    "Contenu principal de l'application",
                    textAlign: TextAlign.center,
                  ),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: screenSize.height / 3),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            VideoDetails(
                              title:
                                  "Le Footballeur Qui A Mis Fin À La Guerre Dans Son Pays",
                              channelName: "@thibs-ytb",
                              subscribers: "1,2 M d'abonnés",
                              views: "56 k vues",
                              timeAgo: "il y a 7 m.",
                              onTitleTap: _showDescriptionBottomSheet,
                            ),
                            const RecommendationCard(
                              title: " José Mourinho GRAND FAVORI au Real, la réponse CASH de Deschamps à Lloris | JT Foot Mercato ",
                              channel: "Foot Mercato",
                              views: "47 k vues",
                              time: "il y a 8 h",
                              duration: "10:03",
                              thumbnailUrl: "",
                            ),
                            const RecommendationCard(
                              title: "Pourquoi ce joueur est une légende ?",
                              channel: "Football News",
                              views: "1,2 M vues",
                              time: "il y a 2 sem",
                              duration: "12:45",
                              thumbnailUrl: "",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        AnimatedPositioned(
          curve: Curves.easeOutBack,
          duration:
              !_inMoove ? const Duration(milliseconds: 400) : Duration.zero,
          top: _isMinimized
              ? _offset.dy
              : MediaQuery.of(context).viewPadding.top,
          left: _isMinimized ? _offset.dx : 0,
          width: _isMinimized ? minimizedSize.width : screenSize.width,
          height: _isMinimized ? minimizedSize.height : screenSize.height / 3,
          child: GestureDetector(
            onTap: () {
              if (!_isMinimized) _hudKey.currentState?.toggleShow();
            },
            onPanStart: (_) {
              if (_isMinimized) _toggleInMove();
            },
            onPanUpdate: (details) {
              if (_isMinimized) {
                setState(() {
                  _offset += details.delta;
                });
              }
            },
            onPanEnd: (_) {
              if (_isMinimized) {
                _snapToClosestCorner(screenSize, minimizedSize);
                _toggleInMove();
              }
            },
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(_isMinimized ? 12 : 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_isMinimized ? 12 : 0),
                child: Stack(
                  children: [
                    Container(
                      height: _isMinimized ? minimizedSize.height * 0.7 : null,
                      color: Colors.black,
                      child: Center(
                        child: _videoController.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: _videoController.value.aspectRatio,
                                child: VideoPlayer(_videoController),
                              )
                            : Container(),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: VideoActionButton(
                        size: _isMinimized ? 15 : null,
                        color: Colors.white,
                        iconPath: _isMinimized
                            ? "assets/svg/type_close.svg"
                            : "assets/svg/reduit.svg",
                        onTap: _toggleVideoSize,
                      ),
                    ),
                    if (!_isMinimized)
                      Positioned.fill(
                        child: MaximisedVideoHud(
                          key: _hudKey,
                          videoController: _videoController,
                        ),
                      ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: VideoProgressIndicator(
                              _videoController,
                              allowScrubbing: true,
                            ),
                          ),
                          if (_isMinimized)
                            _buildMinimizedVideoHud(minimizedSize),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinimizedVideoHud(Size minimizedSize) {
    return SizedBox(
      height: minimizedSize.height * 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VideoActionButton(
            onTap: _rewind10Seconds,
            iconPath: "assets/svg/moin10sec.svg",
          ),
          20.horisontalSpace,
          VideoActionButton(
            onTap: () async {
              _videoController.value.isPlaying
                  ? await _videoController.pause()
                  : await _videoController.play();
              setState(() {});
            },
            iconPath: _videoController.value.isPlaying
                ? "assets/svg/pause.svg"
                : "assets/svg/play_.svg",
          ),
          20.horisontalSpace,
          VideoActionButton(
            onTap: _forward10Seconds,
            iconPath: "assets/svg/plus10sec.svg",
          ),
        ],
      ),
    );
  }
}
