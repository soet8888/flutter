import 'package:flutter/material.dart';

_NotifyingPageViewState _pageState;

class NotifyingPageView extends StatefulWidget {
  final ValueNotifier<double> notifier;
  const NotifyingPageView({Key key, this.notifier}) : super(key: key);
  void setNextPage(String next) => (_pageState?.nextPage(next));
  // @override
  // _NotifyingPageViewState createState() => _NotifyingPageViewState();
  @override
  State createState() {
    _pageState = _NotifyingPageViewState();
    return _pageState;
  }
}

class _NotifyingPageViewState extends State<NotifyingPageView> {
  int _previousPage;
  int _currentPage=0;
  PageController _pageController;
  void _onScroll() {
    // Consider the page changed when the end of the scroll is reached
    // Using onPageChanged callback from PageView causes the page to change when
    // the half of the next card hits the center of the viewport, which is not
    // what I want

    if (_pageController.page.toInt() == _pageController.page) {
      _previousPage = _pageController.page.toInt();
    }
    widget.notifier?.value = _pageController.page - _previousPage;
  }

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.9,
    )..addListener(_onScroll);

    _previousPage = _pageController.initialPage;
    super.initState();
  }

  nextPage(String next) {
    setState(() {
      var _nextIndex;
      if (next == 'left') {
        print("LEFT");
        if (_currentPage == 0) {
          return;
        }
        _nextIndex = _currentPage - 1;
      
      } else {
        print("RIGHT");
        if (_currentPage == 11){
          _nextIndex=0;
          return;
        }
        _nextIndex = _currentPage + 1;
      }
      _currentPage=_nextIndex;
      _pageController.jumpToPage(_nextIndex);
    });
  }

  List<Widget> _pages = List.generate(
    12,
    (index) {
      return Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Text(
          months[index],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      );
    },
  );
  @override
  Widget build(BuildContext context) {
    return PageView(
      onPageChanged: _onPageViewChanged,
      children: _pages,
      controller: _pageController,
    );
  }

  _onPageViewChanged(int index) {
    print("PAGE INDEX: $index");
    setState(() {
      _currentPage = index;
    });
  }
}

List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'Sep',
  'October',
  'Nov',
  'Dec'
];
