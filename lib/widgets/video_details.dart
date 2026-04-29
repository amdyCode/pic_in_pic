import 'package:flutter/material.dart';
import 'package:pic_in_pic/extentions/gap.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class VideoDetails extends StatelessWidget {
  final String title;
  final String channelName;
  final String subscribers;
  final String views;
  final String timeAgo;
  final VoidCallback onTitleTap;

  const VideoDetails({
    super.key,
    required this.title,
    required this.channelName,
    required this.subscribers,
    required this.views,
    required this.timeAgo,
    required this.onTitleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTitleTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                4.veticaleSpace,
                Text(
                  "$channelName • $views • $timeAgo ...plus",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          12.veticaleSpace,
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.red,
                child: Icon(Icons.person, color: Colors.white),
              ),
              10.horisontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      channelName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subscribers,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text("S'abonner"),
              ),
            ],
          ),
          16.veticaleSpace,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildActionButton(Icons.thumb_up_outlined, "1,5 k", isFirst: true),
                _buildActionButton(Icons.thumb_down_outlined, ""),
                _buildActionButton(Icons.share_outlined, "Partager"),
                _buildActionButton(Icons.download_outlined, "Télécharger"),
                _buildActionButton(Icons.cut_outlined, "Extrait"),
              ],
            ),
          ),
          16.veticaleSpace,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Commentaires",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    8.horisontalSpace,
                    Text(
                      "124",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                8.veticaleSpace,
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, size: 16, color: Colors.white),
                    ),
                    8.horisontalSpace,
                    const Expanded(
                      child: Text(
                        "Est-ce le meilleur joueur africain de l'histoire, selon vous ?",
                        style: TextStyle(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, {bool isFirst = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ZoomTapAnimation(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20),
              if (label.isNotEmpty) ...[
                6.horisontalSpace,
                Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
