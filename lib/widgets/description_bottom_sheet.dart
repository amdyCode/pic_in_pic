import 'package:flutter/material.dart';
import 'package:pic_in_pic/extentions/gap.dart';
import 'package:pic_in_pic/widgets/expandable_text_widget.dart';

class DescriptionBottomSheet extends StatelessWidget {
  final String title;
  final String likes;
  final String views;
  final String date;
  final String description;

  const DescriptionBottomSheet({
    super.key,
    required this.title,
    required this.likes,
    required this.views,
    required this.date,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Description",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  20.veticaleSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(likes, "J'aime"),
                      _buildStatItem(views, "vues"),
                      _buildStatItem(date, ""),
                    ],
                  ),
                  20.veticaleSpace,
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECEC), // Subtle pink/red as in Image 2
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpandableTextWidget(
                      text: description,
                      trimLength: 150,
                    ),
                  ),
                  24.veticaleSpace,
                  const Text(
                    "Transcription",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  8.veticaleSpace,
                  const Text(
                    "Suivez la vidéo à l'aide de la transcription.",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  16.veticaleSpace,
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Afficher la transcription"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
      ],
    );
  }
}
