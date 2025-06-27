import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogslife/widgets/role_badge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopRightMenu extends StatefulWidget {
  const TopRightMenu({super.key});

  @override
  State<TopRightMenu> createState() => _TopRightMenuState();
}

class _TopRightMenuState extends State<TopRightMenu> {
  String? _photoUrl;
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _photoUrl = data['photoUrl'];
        _role = data['role'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: CircleAvatar(
        radius: 18,
        backgroundImage: _photoUrl != null && _photoUrl!.isNotEmpty
            ? (_photoUrl!.startsWith('http')
            ? NetworkImage(_photoUrl!)
            : AssetImage(_photoUrl!)) as ImageProvider
            : const AssetImage('assets/images/placeholder_user.png'),
      ),
      onSelected: (value) {
        if (value == 'profile') {
          context.go('/profile');
        } else if (value == 'about') {
          context.go('/about');
        }
      },
      itemBuilder: (context) => [
        if (_role != null)
          PopupMenuItem(
            enabled: false,
            child: Row(
              children: [
                RoleBadge(roleOverride: _role),
              ],
            ),
          ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'profile',
          child: Text('Profile'),
        ),
        const PopupMenuItem(
          value: 'about',
          child: Text('About'),
        ),
      ],
    );
  }
}
