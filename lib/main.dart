import 'package:flutter/material.dart';

void main() => runApp(const HeroDemoApp());

class HeroDemoApp extends StatelessWidget {
  const HeroDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hero Widget Demo',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const GalleryPage(),
    );
  }
}

// Sample data: each item has an id, icon, color and title.
class Item {
  final int id;
  final IconData icon;
  final Color color;
  final String title;
  const Item(this.id, this.icon, this.color, this.title);
}

const items = [
  Item(0, Icons.flutter_dash, Colors.blue, 'Flutter'),
  Item(1, Icons.rocket_launch, Colors.deepOrange, 'Rocket'),
  Item(2, Icons.pets, Colors.teal, 'Pets'),
  Item(3, Icons.music_note, Colors.purple, 'Music'),
  Item(4, Icons.camera_alt, Colors.pink, 'Camera'),
  Item(5, Icons.sports_soccer, Colors.green, 'Soccer'),
];

// PAGE 1: grid of tiles
class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero Gallery')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final item = items[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailPage(item: item)),
            ),
            // The Hero on this page...
            child: Hero(
              tag: 'item-${item.id}', // ...must share this tag with page 2
              child: Container(
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(item.icon, size: 56, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}

// PAGE 2: detail view
class DetailPage extends StatelessWidget {
  final Item item;
  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: Column(
        children: [
          // ...and the matching Hero on this page. Flutter animates between them.
          Hero(
            tag: 'item-${item.id}',
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(color: item.color),
              child: Icon(item.icon, size: 140, color: Colors.white),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'The tile on the previous page "flew" here because both '
              'widgets share the same Hero tag.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
