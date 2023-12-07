import 'package:flutter/material.dart';
import 'package:first_app/models/category.dart' as cat;
import 'package:first_app/models/pub.dart';

const availableCategories = [
  cat.Category(
    id: 'c1',
    title: 'Old Fashioned',
    color: Colors.purple,
  ),
  cat.Category(
    id: 'c2',
    title: 'Late Night',
    color: Colors.red,
  ),
  cat.Category(
    id: 'c3',
    title: 'Beer Garden',
    color: Colors.orange,
  ),
  cat.Category(
    id: 'c4',
    title: 'Central',
    color: Colors.amber,
  ),
  cat.Category(
    id: 'c5',
    title: 'Sports Bar',
    color: Colors.blue,
  ),
  cat.Category(
    id: 'c6',
    title: 'Rooftop',
    color: Colors.green,
  ),
  cat.Category(
    id: 'c7',
    title: 'Cheap',
    color: Colors.lightBlue,
  ),
  cat.Category(
    id: 'c8',
    title: 'Touristy',
    color: Colors.lightGreen,
  ),
  cat.Category(
    id: 'c9',
    title: 'Trendy/Modern',
    color: Colors.pink,
  ),
  cat.Category(
    id: 'c10',
    title: 'Pool/Darts',
    color: Colors.teal,
  ),
  cat.Category(
    id: 'c11',
    title: 'Live Music',
    color: Colors.cyan,
  ),
  cat.Category(
    id: 'c12',
    title: 'Cocktails',
    color: Colors.lightGreen,
  ),
  cat.Category(
    id: 'c13',
    title: 'Whiskey',
    color: Colors.lightGreen,
  ),
];

const pubData = [
  Pub(
    id: 'p1',
    categories: [
      'c1',
    ],
    title: 'Tigh Neachtain',
    affordability: Affordability.affordable,
    imageUrl:
        'https://images.squarespace-cdn.com/content/v1/5b93e7d4c258b4fee2a78c89/1538865968160-ZA1OLQGY65IP0ZNQ8KQM/Tigh+Neactains+Photos-+Boyd+Challenger-2.jpg?format=2500w',
    isAccessible: true,
    isLateNight: false,
  ),
  Pub(
    id: 'p2',
    categories: [
      'c1',
    ],
    title: 'Tigh Coilí',
    affordability: Affordability.affordable,
    imageUrl:
        'https://d2hz75cbudexsj.cloudfront.net/Galway/Restaurant/9763b5e9-4ef9-4f06-b016-30073677fb83.jpg',
    isAccessible: true,
    isLateNight: false,
  ),
  Pub(
    id: 'p3',
    categories: [
      'c2',
    ],
    title: 'The Front Door',
    affordability: Affordability.affordable,
    imageUrl:
        'https://www.frontdoorpub.com/wp-content/uploads/2019/11/74795236_10157168012164051_5862289415946108928_o-700x441.jpg',
    isAccessible: true,
    isLateNight: true,
  ),
  Pub(
    id: 'p4',
    categories: [
      'c2',
    ],
    title: 'The Skeff',
    affordability: Affordability.affordable,
    imageUrl: 'https://thisisgalway.ie/wp-content/uploads/2018/03/Skeff-8.jpg',
    isAccessible: true,
    isLateNight: true,
  ),
  Pub(
    id: 'p5',
    categories: [
      'c2',
    ],
    title: 'The Kings Head',
    affordability: Affordability.affordable,
    imageUrl:
        'https://goodfoodireland.ie/wp-content/uploads/2020/11/paul-and-mary-grealish-the-kings-head-exterior-scaled.jpg',
    isAccessible: true,
    isLateNight: true,
  ),
  Pub(
    id: 'p6',
    categories: [
      'c2',
    ],
    title: 'The Quays',
    affordability: Affordability.affordable,
    imageUrl:
        'https://a.storyblok.com/f/51678/1800x900/587e48fe02/the-quays-galway-ireland-shutterstock-gabriel12.jpg',
    isAccessible: true,
    isLateNight: true,
  ),
  Pub(
    id: 'p7',
    categories: [
      'c5',
    ],
    title: 'The Dew Drop Inn',
    affordability: Affordability.affordable,
    imageUrl:
        'https://galwaybaybrewery.com/wp-content/uploads/2021/10/TheDewDrop.jpg',
    isAccessible: true,
    isLateNight: false,
  ),
  Pub(
    id: 'p8',
    categories: [
      'c4',
    ],
    title: 'The Cellar',
    affordability: Affordability.affordable,
    imageUrl:
        'https://media-cdn.tripadvisor.com/media/photo-s/02/59/7c/fb/located-in-galway-city.jpg',
    isAccessible: true,
    isLateNight: false,
  ),
];
 
 /*final String id;
  final String title;
  final Color color;

  CategoryGridItme(this.id, this.title, this.color);

  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      CategoryMealsScreen.routeName,
      arguments: {
        'id': id,
        'title': title,
        'color': color,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectCategory(context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.title,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.7),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }*/
  