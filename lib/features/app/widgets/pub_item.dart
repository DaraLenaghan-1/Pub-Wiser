import 'package:first_app/features/app/widgets/pub_item_trait.dart';
import 'package:flutter/material.dart';
import 'package:first_app/models/pub.dart';
import 'package:transparent_image/transparent_image.dart';

class PubItem extends StatelessWidget {
  const PubItem({
    super.key,
    required this.pub,
  });

  final Pub pub;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 8.0,
      child: InkWell(
        onTap: () {
          // TODO: Implement onTap functionality, e.g., navigate to a detailed pub page
        },
        child: Stack(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(pub.imageUrl),
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pub.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      /*children: [
                        //PubItemTrait(icon: Icons.accessibility_new, label: label)
                      ],*/
                      children: [
                        Icon(
                          pub.isAccessible ? Icons.accessible : Icons.accessibility_new,
                          color: Colors.white,
                          size: 16.0,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          pub.isAccessible ? 'Accessible' : 'Not Accessible',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(width: 16.0),
                        Icon(
                          pub.isLateNight ? Icons.nightlife : Icons.bedtime,
                          color: Colors.white,
                          size: 16.0,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          pub.isLateNight ? 'Late Night' : 'Closes Early',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
