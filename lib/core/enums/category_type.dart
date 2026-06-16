import 'package:flutter/material.dart';

enum CategoryType {
  food('Makanan & Minuman', Icons.restaurant, Color(0xFFFF7043)),
  transport('Transportasi', Icons.directions_car, Color(0xFF42A5F5)),
  shopping('Belanja', Icons.shopping_bag, Color(0xFFAB47BC)),
  entertainment('Hiburan', Icons.movie, Color(0xFFFFCA28)),
  bills('Tagihan', Icons.receipt, Color(0xFFEF5350)),
  health('Kesehatan', Icons.local_hospital, Color(0xFF66BB6A)),
  education('Pendidikan', Icons.school, Color(0xFF5C6BC0)),
  other('Lainnya', Icons.more_horiz, Color(0xFF78909C));

  final String label;
  final IconData icon;
  final Color color;

  const CategoryType(this.label, this.icon, this.color);
}
