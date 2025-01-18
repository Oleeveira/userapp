// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:userapp/pages/bottom_bar_state.dart';
import 'package:userapp/pages/edit_item_page.dart';
import 'package:userapp/pages/edit_profile.dart';
import 'package:userapp/pages/home_page.dart';
import 'package:userapp/pages/inicial_page.dart';
import 'package:userapp/pages/item_register_page.dart';
import 'package:userapp/pages/legal_entities_profile_page.dart';
import 'package:userapp/pages/legal_entities_login_page.dart';
import 'package:userapp/pages/legal_entities_register_page.dart';
import 'package:userapp/pages/post_page.dart';


class RouteNames {
  static const String legal_entities_login = "legal_entities_login";
  static const String inicial = "inicial";
  static const String email_register = "legal_entities_register_page";
  static const String legal_entities_profile_page = "legal_entities_profile_page";
  static const String edit_profile = "edit_profile";
  static const String item_register_page = "item_register_page";
  static const String home_page = "home_page";
  static const String bottom_bar_state = "bar_state";
  static const String post_page = "post_page";
  static const String item_edit_page = "item_edit";
}

class AppRountersConfiguration {
  static GoRouter returnRouter() {
    return GoRouter(
      initialLocation: '/inicial',
      routes: [
        GoRoute(
          path: '/inicial',
          name: RouteNames.inicial,
          pageBuilder: (context, state) {
            return  const MaterialPage(
              child: InicialPage(),
            );
          },
        ),
        GoRoute(
          path: '/email_register',
          name: RouteNames.email_register,
          pageBuilder: (context, state) {
            return  const MaterialPage(
              child: InstitutionRegisterPage(),
            );
          },
        ),
        GoRoute(
          path: '/item_register_page',
          name: RouteNames.item_register_page,
          pageBuilder: (context, state) {
            return  const MaterialPage(
              child: ItemRegisterPage(),
            );
          },
        ),
        GoRoute(
          path: '/home_page',
          name: RouteNames.home_page,
          pageBuilder: (context, state) {
            return  const MaterialPage(
              child: HomePage(),
            );
          },
        ),
         GoRoute(
      path: '/item_edit/:itemId',
      name: RouteNames.item_edit_page,
      pageBuilder: (context, state) {
        final itemId = state.pathParameters['itemId']!;
        return MaterialPage(
          child: EditItemPage(itemId: itemId),
        );
      },
    ),
        GoRoute(
          path: '/legal_entities_login',
          name: RouteNames.legal_entities_login,
          pageBuilder: (context, state) {
            return  const MaterialPage(
              child: LegalEntitiesLoginPage(),
            );
          },
        ),
        GoRoute(
          path: '/legal_entities_profile_page',
          name: RouteNames.legal_entities_profile_page,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: LegalEntitiesProfilePage(),
            );
          },
        ),
        GoRoute(
          path: '/edit_profile',
          name: RouteNames.edit_profile,
          pageBuilder: (context, state) {
            return  const MaterialPage(
              child: EditProfile(),
            );
          },
        ),
        GoRoute(
          path: '/bar_state',
          name: RouteNames.bottom_bar_state,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: BottomBar(),
            );
          },
        ),
        GoRoute(
          path: '/post_page',
          name: RouteNames.post_page,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: PostPage(),
            );
          },
        ),
      ],
    );
  }
}
