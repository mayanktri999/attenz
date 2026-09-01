import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupId;

  const GroupChatScreen({super.key, required this.groupId});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];

  static const _myName = 'You';

  // Pre-seeded mock messages per group
  static final Map<String, List<_ChatMessage>> _seed = {
    'cs-batch': [
      _ChatMessage(sender: 'Priya Sharma', text: 'Has anyone finished the DS assignment?', time: '10:30 AM', isMe: false),
      _ChatMessage(sender: 'Rahul Gupta', text: 'Not yet, working on it now 🥹', time: '10:32 AM', isMe: false),
      _ChatMessage(sender: _myName, text: 'Almost done, will share notes later', time: '10:35 AM', isMe: true),
      _ChatMessage(sender: 'Priya Sharma', text: 'That would be super helpful, thanks!', time: '10:36 AM', isMe: false),
      _ChatMessage(sender: 'Arjun Mehta', text: 'Guys, Physics class shifted to Room 302 tomorrow', time: '10:45 AM', isMe: false),
      _ChatMessage(sender: _myName, text: 'Got it, thanks for the heads up', time: '10:46 AM', isMe: true),
      _ChatMessage(sender: 'Rahul Gupta', text: 'Also DBMS attendance sheet is out, please check yours', time: '11:00 AM', isMe: false),
    ],
    'bcs-501': [
      _ChatMessage(sender: 'Ms. Kriti Mishra', text: 'Unit 3 notes uploaded on the portal', time: '9:00 AM', isMe: false),
      _ChatMessage(sender: _myName, text: 'Thank you ma\'am!', time: '9:02 AM', isMe: true),
      _ChatMessage(sender: 'Ananya Singh', text: 'When is the internal exam?', time: '9:10 AM', isMe: false),
      _ChatMessage(sender: 'Ms. Kriti Mishra', text: 'Next Wednesday. Syllabus shared in portal.', time: '9:12 AM', isMe: false),
    ],
    'bcs-502': [
      _ChatMessage(sender: 'Dr. Sonam Gupta', text: 'Lab assignment due this Friday end of day', time: '8:50 AM', isMe: false),
      _ChatMessage(sender: 'Rohan Verma', text: 'Do we need to host it or just submit the code?', time: '9:00 AM', isMe: false),
      _ChatMessage(sender: _myName, text: 'Just zip and submit on the portal I think', time: '9:05 AM', isMe: true),
    ],
    'bcs-503': [
      _ChatMessage(sender: 'Amit Kumar', text: 'Anyone solved Q5 of assignment 2?', time: 'Mon 4:00 PM', isMe: false),
      _ChatMessage(sender: _myName, text: 'Yes, it\'s a DP problem. I\'ll share my approach', time: 'Mon 4:20 PM', isMe: true),
      _ChatMessage(sender: 'Amit Kumar', text: 'That would be great, thanks!', time: 'Mon 4:21 PM', isMe: false),
    ],
    'bcs-055': [
      _ChatMessage(sender: 'Sneha Mishra', text: 'Model training code has been uploaded to GitHub', time: 'Mon 2:00 PM', isMe: false),
      _ChatMessage(sender: _myName, text: 'Got it, running it now', time: 'Mon 2:15 PM', isMe: true),
    ],
  };

  static const Map<String, _GroupMeta> _groupMeta = {
    'cs-batch': _GroupMeta(name: 'Computer Science Batch', initials: 'CS', members: 42),
    'bcs-501':  _GroupMeta(name: 'BCS-501 · DBMS', initials: 'DB', members: 18),
    'bcs-502':  _GroupMeta(name: 'BCS-502 · Web Technology', initials: 'WT', members: 20),
    'bcs-503':  _GroupMeta(name: 'BCS-503 · DAA', initials: 'DA', members: 22),
    'bcs-055':  _GroupMeta(name: 'BCS-055 · Machine Learning', initials: 'ML', members: 20),
  };

  @override
  void initState() {
    super.initState();
    _messages.addAll(
      _seed[widget.groupId] ??
          [_ChatMessage(sender: 'System', text: 'No messages yet.', time: '', isMe: false)],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final now = TimeOfDay.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');

    setState(() {
      _messages.add(_ChatMessage(
        sender: _myName,
        text: text,
        time: '$h:$m',
        isMe: true,
      ));
    });
    _controller.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final meta   = _groupMeta[widget.groupId] ??
        const _GroupMeta(name: 'Group', initials: 'GR', members: 0);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.background,

      // ── App bar ────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.background,
        elevation: 0,
        leadingWidth: 40,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                meta.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meta.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${meta.members} members',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ── Message list ───────────────────────────────────────────
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final msg = _messages[i];
                final showSender = !msg.isMe &&
                    (i == 0 || _messages[i - 1].sender != msg.sender);
                return _Bubble(
                  msg: msg,
                  showSender: showSender,
                  isDark: isDark,
                );
              },
            ),
          ),

          // ── Input bar ────────────────────────────────────────
          _InputBar(
            controller: _controller,
            isDark: isDark,
            onSend: _send,
          ),
        ],
      ),
    );
  }
}

// ── Bubble ───────────────────────────────────────────────────────────────────

class _Bubble extends StatelessWidget {
  final _ChatMessage msg;
  final bool showSender;
  final bool isDark;

  const _Bubble({
    required this.msg,
    required this.showSender,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (msg.isMe) {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Text(
                  msg.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
              if (msg.time.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    msg.time,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6, right: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showSender)
              Padding(
                padding: const EdgeInsets.only(bottom: 3, left: 2),
                child: Text(
                  msg.sender,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color:
                    isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                msg.text,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
            ),
            if (msg.time.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 3, left: 2),
                child: Text(
                  msg.time,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Input bar ────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final VoidCallback onSend;

  const _InputBar({
    required this.controller,
    required this.isDark,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.background,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface
                    : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color:
                      isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: 'Message',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data classes ──────────────────────────────────────────────────────────────

class _ChatMessage {
  final String sender;
  final String text;
  final String time;
  final bool isMe;

  const _ChatMessage({
    required this.sender,
    required this.text,
    required this.time,
    required this.isMe,
  });
}

class _GroupMeta {
  final String name;
  final String initials;
  final int members;

  const _GroupMeta({
    required this.name,
    required this.initials,
    required this.members,
  });
}