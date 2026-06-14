import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final String teamA;
  final String teamB;
  final String time;
  final String stage;
  final bool isLive;

  const MatchCard({
    super.key,
    required this.teamA,
    required this.teamB,
    required this.time,
    required this.stage,
    required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isLive ? Colors.redAccent : Colors.white12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isLive ? Colors.redAccent : Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isLive ? 'LIVE' : 'UPCOMING',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                time,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            teamA,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'vs',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            teamB,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            stage,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}