import 'package:flutter/material.dart';
import 'package:flutter_parallex_effect/demo_data.dart';
import 'package:flutter_parallex_effect/rotation3d.dart';

class CardList extends StatefulWidget {
  const CardList({
    super.key,
  });

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList>
    with SingleTickerProviderStateMixin {
  PageController? pageController;
  double _cardWidth = 160;
  double _cardHeight = 200;
  List<City> cities = [];
  double _normalizedOffset = 0;
  double _prevScrollX = 0;
  bool _isScrolling = false;
  double maxRotation = 10;

  AnimationController? _tweenController;
  Tween<double>? _tween;
  Animation<double>? _tweenAnim;
  @override
  void initState() {
    super.initState();
    var data = DemoData();
    cities = data.getCities;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    _cardHeight = (size.height * .48).clamp(300.0, 400.0);
    _cardWidth = _cardHeight * .8;
    pageController = PageController(
        initialPage: 0, viewportFraction: _cardWidth / size.width);
    return Listener(
      onPointerUp: _handlePointerUp,
      child: NotificationListener(
        onNotification: _handleScrollNotifications,
        child: SizedBox(
          child: Rotation3d(
            rotationY: _normalizedOffset * maxRotation,
            child: SizedBox(
              height: _cardHeight,
              child: PageView.builder(
                  controller: pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: ((context, index) {
                    return cardItem(index);
                  })),
            ),
          ),
        ),
      ),
    );
  }

  Container cardItem(int index) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: _cardWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin:
                const EdgeInsets.only(top: 40, left: 12, right: 12, bottom: 12),
            decoration: BoxDecoration(
              color: cities[index].color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4 * _normalizedOffset.abs()),
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10 + 6 * _normalizedOffset.abs()),
              ],
            ),
          ),
          Positioned(top: -15, child: buildImage(index)),
          _buildCityData(index),
        ],
      ),
    );
  }

  Widget _buildCityData(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // The sized box mock the space of the city image
        SizedBox(width: double.infinity, height: _cardHeight * .57),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(cities[index].title, textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(cities[index].description, textAlign: TextAlign.center),
        ),
        const Expanded(
          child: SizedBox(),
        ),
        ElevatedButton(
          onPressed: null,
          child: Text(
            'Learn More'.toUpperCase(),
          ),
        ),
        const SizedBox(height: 8)
      ],
    );
  }

  bool _handleScrollNotifications(Notification notification) {
    //Scroll Update, add to our current offset, but clamp to -1 and 1
    if (notification is ScrollUpdateNotification) {
      if (_isScrolling) {
        double dx = notification.metrics.pixels - _prevScrollX;
        double scrollFactor = .01;
        double newOffset = (_normalizedOffset + dx * scrollFactor);
        _setOffset(newOffset.clamp(-1.0, 1.0));
      }
      _prevScrollX = notification.metrics.pixels;
      //Calculate the index closest to middle
      //_focusedIndex = (_prevScrollX / (_itemWidth + _listItemPadding)).round();
      // widget.onCityChange(widget.cities
      //     .elementAt(_pageController.page.round() % widget.cities.length));
    }
    //Scroll Start
    else if (notification is ScrollStartNotification) {
      _isScrolling = true;
      _prevScrollX = notification.metrics.pixels;
      if (_tween != null) {
        _tweenController!.stop();
      }
    }
    return true;
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_isScrolling) {
      _isScrolling = false;
      _startOffsetTweenToZero();
    }
  }

  void _startOffsetTweenToZero() {
    //The first time this runs, setup our controller, tween and animation. All 3 are required to control an active animation.
    int tweenTime = 1000;
    if (_tweenController == null) {
      //Create Controller, which starts/stops the tween, and rebuilds this widget while it's running
      _tweenController = AnimationController(
          vsync: this, duration: Duration(milliseconds: tweenTime));
      //Create Tween, which defines our begin + end values
      _tween = Tween<double>(begin: -1, end: 0);
      //Create Animation, which allows us to access the current tween value and the onUpdate() callback.
      _tweenAnim = _tween!.animate(
          CurvedAnimation(parent: _tweenController!, curve: Curves.elasticOut))
        //Set our offset each time the tween fires, triggering a rebuild
        ..addListener(() {
          _setOffset(_tweenAnim!.value);
        });
    }
    //Restart the tweenController and inject a new start value into the tween
    _tween!.begin = _normalizedOffset;
    _tweenController!.reset();
    _tween!.end = 0;
    _tweenController!.forward();
  }

  void _setOffset(double value) {
    setState(() {
      _normalizedOffset = value;
    });
  }

  SizedBox buildImage(int index) {
    double maxParallax = 40;
    double globalOffset = _normalizedOffset * maxParallax * 2;
    double cardPadding = 28;
    double containerWidth = _cardWidth - cardPadding;
    return SizedBox(
      height: _cardHeight,
      width: containerWidth,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            layers(
                "images/${cities[index % cities.length].name}/${cities[index % cities.length].name}-Back.png",
                containerWidth * 0.8,
                maxParallax * .1,
                globalOffset),
            layers(
                "images/${cities[index % cities.length].name}/${cities[index % cities.length].name}-Middle.png",
                containerWidth * 0.9,
                maxParallax * .6,
                globalOffset),
            layers(
                "images/${cities[index % cities.length].name}/${cities[index % cities.length].name}-Front.png",
                containerWidth * 0.9,
                maxParallax,
                globalOffset)
          ],
        ),
      ),
    );
  }

  layers(String path, double width, double maxOffset, double globalOffset) {
    double cardPadding = 24;
    double layerWidth = _cardWidth - cardPadding;
    return Positioned(
      left: ((layerWidth * .5) - (width / 2) - _normalizedOffset * maxOffset) +
          globalOffset,
      bottom: _cardHeight * 0.45,
      child: Image.asset(
        path,
        width: width,
      ),
    );
  }
}
