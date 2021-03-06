import 'package:flutter/material.dart';

class CustomFab extends StatefulWidget {
  final Function() fromCamera;
  final Function() fromGallery;
  final String tooltip;

  CustomFab({this.fromCamera, this.fromGallery , this.tooltip});
  @override
  _CustomFabState createState() => _CustomFabState();
}

class _CustomFabState extends State<CustomFab> 
with SingleTickerProviderStateMixin {

  bool isOpened = false;
  AnimationController _controller;
  Animation<Color> _animationColor;
  Animation<double> _animationIcon;
 Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;


  @override
  void initState() {
    
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200))
    ..addListener(() {
      setState(() {});
    });

    _animationIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _animationColor = ColorTween(
      begin: Colors.deepOrange,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.00,
        1.00,
        curve: _curve,
      ),
    ));

    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  animate() {
    if(!isOpened){
      _controller.forward();
    }
    else{
      _controller.reverse();
    }
    isOpened = !isOpened;
  }

    Widget image() {
    return new Container(
      child: FloatingActionButton(
        // Here heroTag is being null because if you use more than 1
        // floating action button(FAB) on a screen without giving them unique or null herotag
        // It will give a error "There are multiple heros with same tag"
        // during Navigation from one page to other
        // Always set hero tags to null or give them unique tags
        // when using more than one FAB
        heroTag: null,
        onPressed: widget.fromGallery,
        tooltip: 'Image',
        child: Icon(Icons.collections),
      ),
    );
  }

  Widget add() {
    return new Container(
      child: FloatingActionButton(
        heroTag: null,
        onPressed: widget.fromCamera,
        tooltip: 'Add',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget toggle() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: _animationColor.value,
      onPressed: animate,
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animationIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: image(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: add(),
        ),
        toggle(),
      ],
    );
  }
}