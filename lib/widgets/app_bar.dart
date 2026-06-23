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
  const NavBar({
    super.key,
    required this.currentPage,
    this.onContactTapped,
  });

  final PageName currentPage;
  final VoidCallback? onContactTapped;

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
        onPressed: () => navigatePage(context, PageName.home),
        icon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset("assets/$brightness/icon.svg", height: 32),
            const SizedBox(width: 8),
            Text("SkillCroma", style: textTheme.titleLarge),
          ],
        ),
      ),
      actions: MediaQuery.of(context).size.width > 800
          ? [
              NavBarLinks(
                label: "Home",
                page: PageName.home,
                isCurrentPage: currentPage == PageName.home,
              ),
              NavBarLinks(
                label: "News",
                page: PageName.news,
                isCurrentPage: currentPage == PageName.news,
              ),
              NavBarLinks(
                label: "Upcoming",
                page: PageName.upcoming,
                isCurrentPage: currentPage == PageName.upcoming,
              ),
              NavBarLinks(
                label: "Leaderboards",
                page: PageName.leaderboards,
                isCurrentPage: currentPage == PageName.leaderboards,
              ),
              NavBarLinks(
                label: "Contact",
                page: PageName.contact,
                isCurrentPage: currentPage == PageName.contact,
                onTap: onContactTapped,
              ),
              SizedBox(width: 24),
            ]
          : [
              PopupMenuButton<PageName>(
                icon: Icon(Icons.menu, color: colorScheme.onPrimaryContainer),
                onSelected: (page) {
                  if (page == PageName.contact && onContactTapped != null) {
                    onContactTapped!();
                  } else {
                    navigatePage(context, page);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<PageName>>[
                  PopupMenuItem<PageName>(
                    value: PageName.home,
                    child: Text('Home'),
                  ),
                  PopupMenuItem<PageName>(
                    value: PageName.news,
                    child: Text('News'),
                  ),
                  PopupMenuItem<PageName>(
                    value: PageName.upcoming,
                    child: Text('Upcoming'),
                  ),
                  PopupMenuItem<PageName>(
                    value: PageName.leaderboards,
                    child: Text('Leaderboards'),
                  ),
                  PopupMenuItem<PageName>(
                    value: PageName.contact,
                    child: Text('Contact'),
                  ),
                ],
              ),
              SizedBox(width: 8),
            ],
    );
  }
}
