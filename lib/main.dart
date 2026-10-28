import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

// ---------------------------------------------------------------------------
// DEMO SWITCHES
// Change one of these to true, then hot reload, to see what each property does.
// All three are false by default, so you see Flutter's default behavior.
// ---------------------------------------------------------------------------

// 1. createRectTween: false = curved path (default), true = straight line
const bool useStraightPath = false;

// 2. placeholderBuilder: false = empty space (default), true = grey box
const bool usePlaceholder = false;

// 3. flightShuttleBuilder: false = corners and icon snap (default),
//    true = corners and icon change smoothly
const bool useShuttle = false;

void main() {
  // 1.0 is normal speed. Set it to 5.0 to see the animation in slow motion.
  timeDilation = 1.0;
  runApp(const HeroDemoApp());
}

// The app itself. It only sets the theme and chooses the first page.
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

// ---------------------------------------------------------------------------
// DATA
// ---------------------------------------------------------------------------

// One tile in the gallery. The id is used to make a unique Hero tag.
class Item {
  final int id;
  final IconData icon;
  final Color color;
  final String title;

  const Item(this.id, this.icon, this.color, this.title);
}

// The list of tiles shown in the gallery.
const items = [
  Item(0, Icons.flutter_dash, Colors.blue, 'Flutter'),
  Item(1, Icons.rocket_launch, Colors.deepOrange, 'Rocket'),
  Item(2, Icons.pets, Colors.teal, 'Pets'),
  Item(3, Icons.music_note, Colors.purple, 'Music'),
  Item(4, Icons.camera_alt, Colors.pink, 'Camera'),
  Item(5, Icons.sports_soccer, Colors.green, 'Soccer'),
];

// ---------------------------------------------------------------------------
// HERO HELPER
// Both pages use this function, so the Hero settings live in one place.
// ---------------------------------------------------------------------------

Widget buildHero(Item item, Widget child) {
  return Hero(
    // The tag links the two Heroes. Same tag on both pages = Flutter animates
    // between them. Every item has its own id, so every tag is unique.
    tag: 'item-${item.id}',

    // Property 1: createRectTween
    // Decides the path the Hero travels. The default is a curved arc.
    // A plain RectTween makes it move in a straight line.
    createRectTween: useStraightPath
        ? (begin, end) => RectTween(begin: begin, end: end)
        : null,

    // Property 2: placeholderBuilder
    // Decides what stays behind while the Hero is flying.
    // The default is an empty space. Here we leave a grey box instead.
    placeholderBuilder: usePlaceholder
        ? (context, heroSize, child) => Container(
              width: heroSize.width,
              height: heroSize.height,
              color: Colors.grey.shade300,
            )
        : null,

    // Property 3: flightShuttleBuilder
    // Decides what the Hero looks like while it is flying.
    // animation.value goes from 0 to 1 during the flight, so we use it to
    // shrink the corner radius and grow the icon a little at a time.
    flightShuttleBuilder: useShuttle
        ? (context, animation, direction, fromContext, toContext) {
            return AnimatedBuilder(
              animation: animation,
              builder: (context, _) => Container(
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(16 * (1 - animation.value)),
                ),
                child: Icon(
                  item.icon,
                  size: 56 + 84 * animation.value,
                  color: Colors.white,
                ),
              ),
            );
          }
        : null,

    // The widget that actually flies.
    child: child,
  );
}

// ---------------------------------------------------------------------------
// PAGE 1: GALLERY
// ---------------------------------------------------------------------------

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero Gallery')),
      // A grid with 2 tiles per row.
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

          // Tapping a tile opens the detail page.
          // This push is what starts the Hero animation.
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailPage(item: item)),
            ),
            // The small rounded tile is the Hero on this page.
            child: buildHero(
              item,
              Container(
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

// ---------------------------------------------------------------------------
// PAGE 2: DETAIL
// ---------------------------------------------------------------------------

class DetailPage extends StatelessWidget {
  final Item item;

  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: Column(
        children: [
          // The big square header is the matching Hero on this page.
          // It has the same tag as the tile, so the tile flies into it.
          buildHero(
            item,
            Container(
              width: double.infinity,
              height: 300,
              color: item.color,
              child: Icon(item.icon, size: 140, color: Colors.white),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'The tile on the previous page flew here because both '
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