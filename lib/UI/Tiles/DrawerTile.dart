import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final PageController _pageController;
  final int _pageNumber;

  DrawerTile(this.icon, this.text, this._pageController, this._pageNumber);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        onTap: () {
          if (Navigator.of(context).canPop()) Navigator.of(context).pop();
          _pageController.jumpToPage(_pageNumber);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: [
              Icon(
                this.icon,
                size: 32,
                color: _pageController.page.round() == _pageNumber
                    ? Theme.of(context).primaryColor
                    : Colors.black,
              ),
              SizedBox(
                width: 32.0,
              ),
              Text(
                text,
                style: TextStyle(
                    color: _pageController.page.round() == _pageNumber
                        ? Theme.of(context).primaryColor
                        : Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
