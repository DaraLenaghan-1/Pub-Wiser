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
];

const pubData = [
  Pub(
    id: 'm1',
    categories: [
      'c1',
    ],
    title: 'Tigh Neachtain',
    affordability: Affordability.affordable,
    imageUrl:
        'https://images.squarespace-cdn.com/content/v1/5b93e7d4c258b4fee2a78c89/1538865968160-ZA1OLQGY65IP0ZNQ8KQM/Tigh+Neactains+Photos-+Boyd+Challenger-2.jpg?format=2500w',
    isAccessible : true,
    isLateNight: false,
  ),
];
 
