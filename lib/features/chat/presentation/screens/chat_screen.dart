import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/app_colors.dart';

/// Group chat list — shows the available study groups.
/// Chat messages are UI-only; no backend chat API is currently available.
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static const _groups = [
    _GroupData(
      id: 'cs-batch',
      name: 'Computer Science Batch',
      initials: 'CS',
      memberCount: 42,
      lastMessage: 'Also DBMS attendance sheet is out, please check yours',
      lastTime: '11:00 AM',
      unread: 3,
    ),
    _GroupData(
      id: 'bcs-501',
      name: 'BCS-501 · DBMS',
      initials: 'DB',
      memberCount: 18,
      lastMessage: 'Notes shared in the group',
      lastTime: 'Yesterday',
      unread: 0,
    ),
    _GroupData(
      id: 'bcs-502',
      name: 'BCS-502 · Web Technology',
      initials: 'WT',
      memberCount: 20,
      lastMessage: 'Lab assignment due Friday',
      lastTime: 'Yesterday',
      unread: 1,
    ),
    _GroupData(
      id: 'bcs-503',
      name: 'BCS-503 · DAA',
      initials: 'DA',
      memberCount: 22,
      lastMessage: 'Anyone solved Q5 of assignment 2?',
      lastTime: 'Mon',
      unread: 0,
    ),
    _GroupData(
      id: 'bcs-055',
      name: 'BCS-055 · Machine Learning',
      initials: 'ML',
      memberCount: 20,
      lastMessage: 'Model training code uploaded',
      lastTime: 'Mon',
      unread: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Groups',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.search,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _groups.length,
                itemBuilder: (context, i) {
                  return _GroupTile(
                    group: _groups[i],
                    isDark: isDark,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  final _GroupData group;
  final bool isDark;

  const _GroupTile({required this.group, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/chat/${group.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(
            horizontal: 4, vertical: 12),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                group.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Name + last message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    group.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Time + unread badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  group.lastTime,
                  style: TextStyle(
                    fontSize: 12,
                    color: group.unread > 0
                        ? AppColors.primary
                        : (isDark
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText),
                  ),
                ),
                const SizedBox(height: 4),
                if (group.unread > 0)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${group.unread}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupData {
  final String id;
  final String name;
  final String initials;
  final int memberCount;
  final String lastMessage;
  final String lastTime;
  final int unread;

  const _GroupData({
    required this.id,
    required this.name,
    required this.initials,
    required this.memberCount,
    required this.lastMessage,
    required this.lastTime,
    required this.unread,
  });
}