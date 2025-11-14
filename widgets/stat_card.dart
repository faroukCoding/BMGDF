import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color? valueColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const StatCard({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
    this.valueColor,
    this.backgroundColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? Color(0xFF1A1A2E).withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF00ADB5).withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF00ADB5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                icon,
                style: TextStyle(fontSize: 24),
              ),
            ),
            
            SizedBox(height: 12),
            
            // Value
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: valueColor ?? Color(0xFF00ADB5),
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 6),
            
            // Label
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

// Stat Card with progress indicator
class StatCardWithProgress extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final double progress;
  final Color progressColor;

  const StatCardWithProgress({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
    required this.progress,
    this.progressColor = const Color(0xFF00ADB5),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E).withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF00ADB5).withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFF00ADB5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(icon, style: TextStyle(fontSize: 20)),
              ),
              
              SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00ADB5),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          // Progress bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            borderRadius: BorderRadius.circular(4),
          ),
          
          SizedBox(height: 4),
          
          // Progress percentage
          Text(
            '${(progress * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// Grid of stat cards
class StatsGrid extends StatelessWidget {
  final List<StatCard> cards;
  final int crossAxisCount;
  final double spacing;

  const StatsGrid({
    Key? key,
    required this.cards,
    this.crossAxisCount = 3,
    this.spacing = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      children: cards,
    );
  }
}