import 'package:flutter/material.dart';

class CustomTabs extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> tabContents;
  final bool isScrollable;
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;
  final ValueChanged<int>? onTabChanged;

  const CustomTabs({
    Key? key,
    required this.tabs,
    required this.tabContents,
    this.isScrollable = false,
    this.activeColor = const Color(0xFF00ADB5),
    this.inactiveColor = Colors.white,
    this.backgroundColor = const Color(0xFF1A1A2E),
    this.onTabChanged,
  }) : super(key: key);

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      widget.onTabChanged?.call(_tabController.index);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: widget.isScrollable,
            indicator: BoxDecoration(
              color: widget.activeColor,
              borderRadius: BorderRadius.circular(10),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: widget.inactiveColor,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            tabs: widget.tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
        
        SizedBox(height: 16),
        
        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabContents,
          ),
        ),
      ],
    );
  }
}

// Alternative: Simple tab switcher without TabController
class SimpleTabs extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> contents;
  final Color activeColor;
  final Color inactiveColor;

  const SimpleTabs({
    Key? key,
    required this.tabs,
    required this.contents,
    this.activeColor = const Color(0xFF00ADB5),
    this.inactiveColor = Colors.white70,
  }) : super(key: key);

  @override
  _SimpleTabsState createState() => _SimpleTabsState();
}

class _SimpleTabsState extends State<SimpleTabs> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Headers
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF1A1A2E).withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: List.generate(widget.tabs.length, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _currentIndex == index 
                          ? widget.activeColor 
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.tabs[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        
        SizedBox(height: 16),
        
        // Tab Content
        Expanded(
          child: widget.contents[_currentIndex],
        ),
      ],
    );
  }
}

// Icon Tabs
class IconTabs extends StatefulWidget {
  final List<IconTab> tabs;
  final Color activeColor;
  final Color inactiveColor;

  const IconTabs({
    Key? key,
    required this.tabs,
    this.activeColor = const Color(0xFF00ADB5),
    this.inactiveColor = Colors.white70,
  }) : super(key: key);

  @override
  _IconTabsState createState() => _IconTabsState();
}

class _IconTabsState extends State<IconTabs> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Headers with Icons
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF1A1A2E).withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: List.generate(widget.tabs.length, (index) {
              final tab = widget.tabs[index];
              final isActive = _currentIndex == index;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                    tab.onTap?.call();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isActive ? widget.activeColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tab.icon,
                          color: isActive ? Colors.white : widget.inactiveColor,
                          size: 20,
                        ),
                        SizedBox(height: 4),
                        Text(
                          tab.label,
                          style: TextStyle(
                            color: isActive ? Colors.white : widget.inactiveColor,
                            fontSize: 12,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        
        SizedBox(height: 16),
        
        // Tab Content
        Expanded(
          child: widget.tabs[_currentIndex].content,
        ),
      ],
    );
  }
}

class IconTab {
  final IconData icon;
  final String label;
  final Widget content;
  final VoidCallback? onTap;

  IconTab({
    required this.icon,
    required this.label,
    required this.content,
    this.onTap,
  });
}