import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cart Animation',
      home: YourPage(),
    );
  }
}

class YourPage extends StatefulWidget {
  @override
  _YourPageState createState() => _YourPageState();
}

class _YourPageState extends State<YourPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isItemOrdered = false;
  GlobalKey _itemKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isItemOrdered = false;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addToCart() {
    setState(() {
      _isItemOrdered = true;
    });
    final RenderBox itemRenderBox = _itemKey.currentContext!.findRenderObject() as RenderBox;
    final itemPosition = itemRenderBox.localToGlobal(Offset.zero);
    final cartRenderBox = _cartKey.currentContext!.findRenderObject() as RenderBox;
    final cartPosition = cartRenderBox.localToGlobal(Offset.zero);

    final dx = cartPosition.dx - itemPosition.dx;
    final dy = cartPosition.dy - itemPosition.dy;

    _controller.reset();
    _controller.forward();
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  GlobalKey _cartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Animation'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CartAnimation(
              animation: _animation,
              isItemOrdered: _isItemOrdered,
              cartKey: _cartKey,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            key: _itemKey,
            title: Text('Food Item $index'),
            onTap: () {
              _addToCart();
            },
          );
        },
      ),
    );
  }
}

class CartAnimation extends StatelessWidget {
  final Animation<double> animation;
  final bool isItemOrdered;
  final GlobalKey cartKey;

  CartAnimation({required this.animation, required this.isItemOrdered, required this.cartKey});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          key: cartKey,
          onPressed: () {},
          icon: Icon(Icons.shopping_cart),
        ),
        if (isItemOrdered)
          Positioned(
            left: 0,
            top: 0,
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(100 * animation.value, 0),
                  child: Icon(Icons.food_bank),
                );
              },
            ),
          ),
      ],
    );
  }
}
