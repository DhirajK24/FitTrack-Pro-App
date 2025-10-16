import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_button.dart';
import '../../design_system/components/app_card.dart';
import '../../design_system/components/app_navigation.dart';

class NutritionChatScreen extends StatefulWidget {
  const NutritionChatScreen({super.key});

  @override
  State<NutritionChatScreen> createState() => _NutritionChatScreenState();
}

class _NutritionChatScreenState extends State<NutritionChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

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

  void _addWelcomeMessage() {
    _messages.add(
      ChatMessage(
        text:
            "Hi! Tell me your dietary preference and time budget. Example: 'Vegetarian, ₹200/day, 30 minutes cook time'",
        isBot: true,
        isAIGenerated: true,
        attachments: [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBarWithBack(
        title: 'Nutrition Coach',
        onBackPressed: () => context.go('/nutrition-coach'),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(DesignTokens.spacing4),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          // Quick prompts
          if (_messages.length == 1) _buildQuickPrompts(),
          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacing3),
      child: Row(
        mainAxisAlignment: message.isBot
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isBot) ...[
            // Bot avatar
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: DesignTokens.accent2,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'FT',
                  style: TextStyle(
                    color: DesignTokens.brandDark,
                    fontSize: 12,
                    fontWeight: DesignTokens.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacing2),
          ],
          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(DesignTokens.spacing3),
              decoration: BoxDecoration(
                color: message.isBot
                    ? DesignTokens.surface
                    : const Color(0xFF333333),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.isAIGenerated)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing2,
                        vertical: DesignTokens.spacing1,
                      ),
                      decoration: BoxDecoration(
                        color: DesignTokens.accent1.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'AI-generated',
                        style: AppTextStyles.caption.copyWith(
                          color: DesignTokens.accent1,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  if (message.isAIGenerated)
                    const SizedBox(height: DesignTokens.spacing2),
                  Text(
                    message.text,
                    style: AppTextStyles.body.copyWith(
                      color: DesignTokens.textLight,
                    ),
                  ),
                  if (message.attachments.isNotEmpty) ...[
                    const SizedBox(height: DesignTokens.spacing2),
                    ...message.attachments.map(
                      (attachment) => _buildAttachment(attachment),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (!message.isBot) ...[
            const SizedBox(width: DesignTokens.spacing2),
            // User avatar
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: DesignTokens.accent1,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person,
                color: DesignTokens.brandDark,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAttachment(ChatAttachment attachment) {
    switch (attachment.type) {
      case AttachmentType.mealCard:
        return _buildMealCard(attachment.data as Map<String, dynamic>);
      case AttachmentType.image:
        return _buildImageAttachment(attachment.data as String);
    }
  }

  Widget _buildMealCard(Map<String, dynamic> mealData) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mealData['title'] ?? 'Meal Plan',
            style: AppTextStyles.bodyMedium.copyWith(
              color: DesignTokens.textLight,
              fontWeight: DesignTokens.semiBold,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing2),
          ...(mealData['meals'] as List<dynamic>).map(
            (meal) => Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacing1),
              child: Row(
                children: [
                  Text(
                    '${meal['name']}: ',
                    style: AppTextStyles.body.copyWith(
                      color: DesignTokens.textMuted,
                    ),
                  ),
                  Text(
                    meal['description'],
                    style: AppTextStyles.body.copyWith(
                      color: DesignTokens.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spacing2),
          Row(
            children: [
              AppButton(
                text: 'Save Plan',
                onPressed: () => _saveMealPlan(mealData),
                size: AppButtonSize.small,
              ),
              const SizedBox(width: DesignTokens.spacing2),
              AppButton(
                text: 'Edit',
                onPressed: () => _editMealPlan(mealData),
                variant: AppButtonVariant.secondary,
                size: AppButtonSize.small,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageAttachment(String imagePath) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacing3),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: DesignTokens.accent2,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'FT',
                style: TextStyle(
                  color: DesignTokens.brandDark,
                  fontSize: 12,
                  fontWeight: DesignTokens.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacing2),
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacing3),
            decoration: BoxDecoration(
              color: DesignTokens.surface,
              borderRadius: BorderRadius.circular(16),
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
            color: DesignTokens.accent1.withOpacity(0.3 + (0.7 * value)),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildQuickPrompts() {
    final prompts = [
      'Create low-carb day',
      'Vegetarian 2000 kcal',
      'Weekly grocery list',
    ];

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Prompts',
            style: AppTextStyles.bodyMedium.copyWith(
              color: DesignTokens.textLight,
              fontWeight: DesignTokens.semiBold,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing2),
          Wrap(
            spacing: DesignTokens.spacing2,
            runSpacing: DesignTokens.spacing2,
            children: prompts
                .map((prompt) => _buildPromptChip(prompt))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptChip(String text) {
    return GestureDetector(
      onTap: () => _sendMessage(text),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing3,
          vertical: DesignTokens.spacing2,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: DesignTokens.border),
        ),
        child: Text(
          text,
          style: AppTextStyles.caption.copyWith(color: DesignTokens.textLight),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing4),
      decoration: BoxDecoration(
        color: DesignTokens.surface,
        border: Border(top: BorderSide(color: DesignTokens.border)),
      ),
      child: Row(
        children: [
          // Attach button
          IconButton(
            icon: const Icon(Icons.attach_file),
            color: DesignTokens.textMuted,
            onPressed: _attachImage,
          ),
          // Message input
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: DesignTokens.brandDark,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: DesignTokens.border),
              ),
              child: TextField(
                controller: _messageController,
                style: AppTextStyles.body.copyWith(
                  color: DesignTokens.textLight,
                ),
                decoration: InputDecoration(
                  hintText: 'Ask about nutrition...',
                  hintStyle: AppTextStyles.body.copyWith(
                    color: DesignTokens.textMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacing4,
                    vertical: DesignTokens.spacing3,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (value) => _sendMessage(value),
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacing2),
          // Send button
          GestureDetector(
            onTap: () => _sendMessage(_messageController.text),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: DesignTokens.accent1,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.send,
                color: DesignTokens.brandDark,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isBot: false,
          isAIGenerated: false,
          attachments: [],
        ),
      );
      _messageController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate bot response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(_generateBotResponse(text));
        });
        _scrollToBottom();
      }
    });
  }

  ChatMessage _generateBotResponse(String userMessage) {
    // Simple response generation based on keywords
    if (userMessage.toLowerCase().contains('low-carb')) {
      return ChatMessage(
        text: "Here's a 1-day vegetarian meal plan. (Macros shown)",
        isBot: true,
        isAIGenerated: true,
        attachments: [
          ChatAttachment(
            type: AttachmentType.mealCard,
            data: {
              'title': 'Low-Carb Vegetarian Day',
              'meals': [
                {
                  'name': 'Breakfast',
                  'description': 'Paneer scramble with spinach',
                },
                {'name': 'Lunch', 'description': 'Cauliflower rice with dal'},
                {'name': 'Dinner', 'description': 'Grilled paneer with salad'},
              ],
            },
          ),
        ],
      );
    } else if (userMessage.toLowerCase().contains('vegetarian')) {
      return ChatMessage(
        text: "Here's a balanced vegetarian meal plan for 2000 kcal:",
        isBot: true,
        isAIGenerated: true,
        attachments: [
          ChatAttachment(
            type: AttachmentType.mealCard,
            data: {
              'title': 'Vegetarian 2000 kcal Plan',
              'meals': [
                {
                  'name': 'Breakfast',
                  'description': 'Oats with nuts and fruits',
                },
                {'name': 'Lunch', 'description': 'Rajma chawal with salad'},
                {
                  'name': 'Dinner',
                  'description': 'Dal with roti and vegetables',
                },
              ],
            },
          ),
        ],
      );
    } else {
      return ChatMessage(
        text:
            "I'd be happy to help you with that! Could you provide more details about your dietary preferences and goals?",
        isBot: true,
        isAIGenerated: true,
        attachments: [],
      );
    }
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

  void _attachImage() {
    // TODO: Implement image attachment
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image attachment coming soon!'),
        backgroundColor: DesignTokens.accent1,
      ),
    );
  }

  void _saveMealPlan(Map<String, dynamic> mealData) {
    // TODO: Save meal plan
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Meal plan saved!'),
        backgroundColor: DesignTokens.accent1,
      ),
    );
  }

  void _editMealPlan(Map<String, dynamic> mealData) {
    // TODO: Edit meal plan
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit functionality coming soon!'),
        backgroundColor: DesignTokens.accent1,
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isBot;
  final bool isAIGenerated;
  final List<ChatAttachment> attachments;

  ChatMessage({
    required this.text,
    required this.isBot,
    required this.isAIGenerated,
    required this.attachments,
  });
}

class ChatAttachment {
  final AttachmentType type;
  final dynamic data;

  ChatAttachment({required this.type, required this.data});
}

enum AttachmentType { mealCard, image }
