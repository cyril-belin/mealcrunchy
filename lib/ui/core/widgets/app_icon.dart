import 'package:flutter/material.dart';

IconData appIcon(String name) {
  return switch (name) {
    'auto_awesome' => Icons.auto_awesome_rounded,
    'bakery' => Icons.bakery_dining_rounded,
    'bed' => Icons.bed_rounded,
    'bolt' => Icons.bolt_rounded,
    'cookie' => Icons.cookie_rounded,
    'desk' => Icons.desk_rounded,
    'eco' => Icons.eco_rounded,
    'egg' => Icons.egg_rounded,
    'fitness' => Icons.fitness_center_rounded,
    'grain' => Icons.grain_rounded,
    'ice_cream' => Icons.icecream_rounded,
    'info' => Icons.info_rounded,
    'light_mode' => Icons.light_mode_rounded,
    'nutrition' => Icons.restaurant_menu_rounded,
    'public' => Icons.public_rounded,
    'restaurant' => Icons.restaurant_rounded,
    'self_improvement' => Icons.self_improvement_rounded,
    'set_meal' => Icons.set_meal_rounded,
    'straightener' => Icons.straighten_rounded,
    'target' => Icons.track_changes_rounded,
    'timer' => Icons.timer_rounded,
    'walk' => Icons.directions_walk_rounded,
    'warning' => Icons.warning_rounded,
    _ => Icons.circle_rounded,
  };
}
