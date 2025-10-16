import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_button.dart';
import '../../design_system/components/app_card.dart';
import '../../design_system/components/app_input.dart';
import '../../design_system/components/app_navigation.dart';
import '../../design_system/components/app_modal.dart';

class AINutritionChatScreen extends StatefulWidget {
  const AINutritionChatScreen({super.key});

  @override
  State<AINutritionChatScreen> createState() => _AINutritionChatScreenState();
}

class _AINutritionChatScreenState extends State<AINutritionChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  final List<String> _quickPrompts = [
    'What should I eat for breakfast?',
    'Help me plan my meals today',
    'I need more protein in my diet',
    'What are healthy snacks?',
    'Calculate my macros',
  ];

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBarWithBack(
        title: 'AI Nutrition Coach',
        onBackPressed: () => context.go('/dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: _messages.isEmpty
                ? _buildWelcomeScreen()
                : _buildMessagesList(),
          ),
          // Typing indicator
          if (_isTyping) _buildTypingIndicator(),
          // Input area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: DesignTokens.accent1.withOpacity(0.2),
              borderRadius: BorderRadius.circular(DesignTokens.radiusXLarge),
            ),
            child: const Icon(
              Icons.psychology,
              size: 60,
              color: DesignTokens.accent1,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing6),
          Text(
            'AI Nutrition Coach',
            style: AppTextStyles.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacing2),
          Text(
            'Get personalized nutrition advice, meal plans, and macro calculations powered by AI',
            style: AppTextStyles.body.copyWith(color: DesignTokens.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacing8),
          // Quick prompts
          Text('Quick Questions', style: AppTextStyles.h4),
          const SizedBox(height: DesignTokens.spacing4),
          Wrap(
            spacing: DesignTokens.spacing2,
            runSpacing: DesignTokens.spacing2,
            children: _quickPrompts.map((prompt) {
              return AppChip(
                label: prompt,
                onDeleted: () => _sendMessage(prompt),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: AppSpacing.screenPadding,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacing4),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: DesignTokens.accent1,
                borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
              ),
              child: const Icon(
                Icons.psychology,
                color: DesignTokens.brandDark,
                size: 20,
              ),
            ),
            const SizedBox(width: DesignTokens.spacing2),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(DesignTokens.spacing3),
              decoration: BoxDecoration(
                color: isUser ? DesignTokens.accent1 : DesignTokens.surface,
                borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.content is String)
                    Text(
                      message.content as String,
                      style: AppTextStyles.body.copyWith(
                        color: isUser
                            ? DesignTokens.brandDark
                            : DesignTokens.textLight,
                      ),
                    )
                  else if (message.content is MealCard)
                    message.content as Widget,
                  const SizedBox(height: DesignTokens.spacing1),
                  Text(
                    _formatTime(message.timestamp),
                    style: AppTextStyles.caption.copyWith(
                      color: isUser
                          ? DesignTokens.brandDark.withOpacity(0.7)
                          : DesignTokens.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: DesignTokens.spacing2),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: DesignTokens.surface,
                borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
              ),
              child: const Icon(
                Icons.person,
                color: DesignTokens.textLight,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: AppSpacing.screenPadding,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: DesignTokens.accent1,
              borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            ),
            child: const Icon(
              Icons.psychology,
              color: DesignTokens.brandDark,
              size: 20,
            ),
          ),
          const SizedBox(width: DesignTokens.spacing2),
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacing3),
            decoration: BoxDecoration(
              color: DesignTokens.surface,
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: DesignTokens.textMuted.withOpacity(0.3 + (value * 0.7)),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: AppSpacing.screenPadding,
      decoration: BoxDecoration(
        color: DesignTokens.surface,
        border: Border(top: BorderSide(color: DesignTokens.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppInput(
              controller: _messageController,
              hintText: 'Ask about nutrition, meals, or macros...',
              textInputAction: TextInputAction.send,
              onSubmitted: (value) => _sendMessage(value),
              maxLines: 3,
            ),
          ),
          const SizedBox(width: DesignTokens.spacing3),
          AppIconButton(
            icon: Icons.send,
            onPressed: () => _sendMessage(_messageController.text),
            size: AppButtonSize.medium,
          ),
        ],
      ),
    );
  }

  void _addWelcomeMessage() {
    _messages.add(
      ChatMessage(
        content:
            'Hi! I\'m your AI Nutrition Coach. I can help you with meal planning, macro calculations, and nutrition advice. What would you like to know?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          content: text.trim(),
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      _generateAIResponse(text.trim());
    });
  }

  void _generateAIResponse(String userMessage) {
    setState(() {
      _isTyping = false;
    });

    // Simulate AI response based on user input
    String response;
    Widget? mealCard;

    if (userMessage.toLowerCase().contains('breakfast')) {
      response = 'Here\'s a nutritious breakfast option for you:';
      mealCard = MealCard(
        name: 'Protein Oatmeal Bowl',
        calories: 420,
        protein: 25.0,
        carbs: 45.0,
        fat: 12.0,
        imageUrl:
            'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=200&h=200&fit=crop',
        isAIGenerated: true,
      );
    } else if (userMessage.toLowerCase().contains('meal plan')) {
      response =
          'I\'ve created a personalized meal plan for you. Here\'s one of the meals:';
      mealCard = MealCard(
        name: 'Grilled Chicken & Quinoa Bowl',
        calories: 580,
        protein: 35.0,
        carbs: 55.0,
        fat: 18.0,
        imageUrl:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=200&h=200&fit=crop',
        isAIGenerated: true,
      );
    } else if (userMessage.toLowerCase().contains('protein')) {
      response =
          'Great question! Here are some excellent protein sources:\n\n• Lean meats (chicken, turkey, fish)\n• Eggs and dairy products\n• Legumes (beans, lentils, chickpeas)\n• Nuts and seeds\n• Greek yogurt and cottage cheese\n\nAim for 0.8-1.2g of protein per kg of body weight daily.';
    } else if (userMessage.toLowerCase().contains('macros')) {
      response =
          'Based on your profile, here\'s your recommended macro breakdown:\n\n• Protein: 25-30% (150-180g)\n• Carbs: 45-50% (225-300g)\n• Fat: 20-25% (67-83g)\n\nThis will help you maintain energy and support your fitness goals.';
    } else {
      response =
          'That\'s a great question! I\'d be happy to help you with that. Could you provide more details about your specific nutrition goals or dietary preferences?';
    }

    setState(() {
      _messages.add(
        ChatMessage(
          content: mealCard ?? response,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
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

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showOptions() {
    AppModalBottomSheet.show(
      context: context,
      title: 'Chat Options',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.clear_all),
            title: const Text('Clear Chat'),
            onTap: () {
              Navigator.of(context).pop();
              _clearChat();
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Export Chat'),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Export chat
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Nutrition Settings'),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Navigate to nutrition settings
            },
          ),
        ],
      ),
    );
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _addWelcomeMessage();
    });
  }
}

class ChatMessage {
  final dynamic content; // String or Widget
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}
