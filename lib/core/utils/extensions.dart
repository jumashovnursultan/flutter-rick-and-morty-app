import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/core/themes/app_colors.dart';

import '../../domain/entities/character.dart';

extension CharacterX on Character {
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'alive':
        return AppColors.alive;
      case 'dead':
        return AppColors.dead;
      default:
        return AppColors.unknown;
    }
  }
}
