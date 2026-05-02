// Copyright (c) 2026 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../../models/footer_config.dart';
import 'footer_utils.dart';

/// Upgrade / premium CTA footer with an animated gradient background.
///
/// Draws attention with a colourful gradient panel and a prominent button
/// that calls [NovaFooterConfig.onUpgradeTap]. Use this footer to upsell
/// a paid plan, a Pro tier, or any premium feature.
///
/// Layout:
/// ```
/// ┌──────────────────────────────────────┐
/// │  ✨ Upgrade to Pro                   │
/// │     Unlock all features   [Upgrade]  │
/// └──────────────────────────────────────┘
/// ```
class NovaFooterUpgrade extends StatefulWidget {
  /// Creates a [NovaFooterUpgrade].
  const NovaFooterUpgrade({super.key, required this.config, this.theme});

  /// Footer configuration.
  final NovaFooterConfig config;

  /// Optional theme override.
  final ThemeData? theme;

  @override
  State<NovaFooterUpgrade> createState() => _NovaFooterUpgradeState();
}

class _NovaFooterUpgradeState extends State<NovaFooterUpgrade>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerCtrl;
  late final Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _shimmerAnim = CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme ?? Theme.of(context);
    final config = widget.config;
    final height = config.height ?? 88.0;
    final colors = config.gradientColors ??
        NovaFooterWidgetUtils.kDefaultUpgradeGradient;

    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (context, child) {
        final shimmerOpacity = 0.06 + _shimmerAnim.value * 0.08;
        return Container(
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Stack(
            children: [
              // Shimmer overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withAlpha((shimmerOpacity * 255).round()),
                        Colors.transparent,
                        Colors.white.withAlpha((shimmerOpacity * 255).round()),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: config.padding ??
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Star icon
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Title + subtitle
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            config.upgradeTitle ?? 'Upgrade to Pro',
                            style: t.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (config.upgradeSubtitle != null)
                            Text(
                              config.upgradeSubtitle!,
                              style: t.textTheme.labelSmall?.copyWith(
                                color: Colors.white.withAlpha(200),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // CTA button
                    if (config.onUpgradeTap != null)
                      ElevatedButton(
                        onPressed: config.onUpgradeTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: colors.first,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: t.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          config.upgradeCTALabel ?? 'Upgrade',
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
