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
        borderRadius: BorderRadius.circular(16.0), //8
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 8.0, //add shadow
      child: InkWell(
        onTap: () {},
        child: Stack(
          //Stack is a widget that allows you to stack multiple widgets on top of each other, by default, they are placed on top of each other in the order they are added to the stack
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(pub.imageUrl),
              fit: BoxFit
                  .cover, //cover the entire card with the image (no white space)
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
                    vertical: 8.0, horizontal: 16.0), // 6, 44
                child: Column(
                  children: [
                    Text(
                      pub.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis, //very long text
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.accessible,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 6.0,
                        ),
                        Text(
                          pub.isAccessible ? 'Accessible' : 'Not Accessible',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        const Icon(
                          Icons.nightlife,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 6.0,
                        ),
                        Text(
                          pub.isLateNight ? 'Late Night' : 'Not Late Night',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    )
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
