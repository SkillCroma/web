// Packages
import 'package:svg_flutter/svg_flutter.dart';
import 'package:flutter/material.dart';

// Widgets
import 'package:skillcroma/widgets/nav_bar_links.dart';

// Values
import 'package:skillcroma/values.dart';

// Functions
import 'package:skillcroma/functions.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key, required this.currentPage});

  final pageName currentPage;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final brightness =
        View.of(context).platformDispatcher.platformBrightness ==
            Brightness.dark
        ? "light"
        : "dark";
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return AppBar(
      centerTitle: false,
      backgroundColor: colorScheme.primaryContainer,
      title: IconButton(
        onPressed: () => navigatePage(context, .home),
        icon: Row(
          mainAxisSize: .min,
          children: [
            SvgPicture.asset("assets/$brightness/icon.svg", height: 32),
            const SizedBox(width: 8),
            Text("SkillCroma", style: textTheme.titleLarge),
          ],
        ),
      ),
      actions: [
        NavBarLinks(
          label: "Home",
          page: .home,
          isCurrentPage: currentPage == .home,
        ),
        NavBarLinks(
          label: "News",
          page: .news,
          isCurrentPage: currentPage == .news,
        ),
        NavBarLinks(
          label: "Upcoming",
          page: .upcoming,
          isCurrentPage: currentPage == .upcoming,
        ),
        NavBarLinks(
          label: "Leaderboards",
          page: .leaderboards,
          isCurrentPage: currentPage == .leaderboards,
        ),
        NavBarLinks(
          label: "Contact",
          page: .contact,
          isCurrentPage: currentPage == .contact,
        ),
        SizedBox(width: 24),
      ],
    );
  }
}
