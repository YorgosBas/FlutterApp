import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive/hive.dart';

import '../../pages/authentication/AuthPage.dart';
import '../../Router.dart';
import '../../bloc/auth/exports.dart';
import '../../bloc/notifications/exports.dart';
import '../../bloc/theme/exports.dart';
import '../AbstractPage.dart';
import '../fragments/CheckableElement.dart';
import '../fragments/ExpandableElement.dart';
import '../fragments/SectionHeader.dart';
import '../fragments/TappableElement.dart';
import '../fragments/ToggleableElement.dart';

class Settings extends AbstractPage {
  Settings({Key key})
      : super(
          key: key,
          appBarTitle: 'Settings',
          navIcon: Icons.settings,
        );

  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends PageState<Settings> {
  bool aa = false;
  final contactsBox = Hive.box('contacts');

  @override
  Widget body(GlobalKey<ScaffoldState> scfKey) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildProfileInfo(),
          _buildAppOptions(),
        ],
      ),
    );
  }

  Column _buildProfileInfo() {
    return Column(
      children: <Widget>[
        SectionHeader(
          title: 'Profile Information',
          extras: Icon(Icons.person_outline),
        ),
        TappableElement(
          label: 'Edit Account',
          icon: Icons.person_pin_circle,
          onTap: () => Router.push(context, '/edit_account'),
        ),
        TappableElement(
          label: 'Update Grades',
          icon: Icons.loop,
          onTap: () => Router.push(context, '/update_grades'),
        ),
        TappableElement(
          label: 'Download Data',
          icon: Icons.file_download,
          onTap: () => Router.push(context, '/download_data'),
        ),
        TappableElement(
          label: 'Request Deletion',
          icon: Icons.delete,
          color: Colors.red.shade400,
          onTap: () => Router.push(context, '/request_deletion'),
        ),
      ],
    );
  }

  Column _buildAppOptions() {
    final ThemeBloc themeBloc = BlocProvider.of<ThemeBloc>(context);
    final NotifBloc notifBloc = BlocProvider.of<NotifBloc>(context);

    return Column(
      children: <Widget>[
        SectionHeader(
          title: 'App Options',
          extras: Icon(Icons.build),
        ),
        BlocBuilder<ThemeBloc, ThemeState>(
          bloc: themeBloc,
          builder: (BuildContext context, ThemeState themeState) {
            return ToggleableElement(
              name: 'Dark Mode',
              icon: Icons.phone_android,
              toggle: (bool toggleDark) => themeBloc.dispatch(
                toggleDark ? ToggleDark() : ToggleLight(),
              ),
              isOn: themeState is DarkTheme,
            );
          },
        ),
        BlocBuilder<NotifBloc, NotifState>(
          bloc: notifBloc,
          builder: (BuildContext context, NotifState notifState) {
            return ExpandableElement(
              name: 'Notifications',
              icon: Icons.alarm,
              column: Column(
                children: <Widget>[
                  CheckableElement(
                    name: 'New Semester',
                    icon: Icons.calendar_today,
                    toggle: (bool semesterOn) => notifBloc.dispatch(
                      semesterOn ? SubToSemester() : UnsubFromSemester(),
                    ),
                    isOn: notifState.hasSemester,
                  ),
                  CheckableElement(
                    name: 'Missing Grades',
                    icon: Icons.warning,
                    toggle: (bool gradesOn) => notifBloc
                        .dispatch(gradesOn ? SubToGrades() : UnsubFromGrades()),
                    isOn: notifState.hasGrades,
                  ),
                ],
              ),
            );
          },
        ),
        TappableElement(
          label:
              'Rate us on ${Platform.isAndroid ? 'Google Play Store' : 'App Store'}',
          icon: Icons.thumb_up,
          onTap: () async => await launch(
            Platform.isAndroid ? 'https://google.com' : 'https://apple.com',
          ),
        ),
        TappableElement(
          label: 'Log Out',
          icon: Icons.exit_to_app,
          color: Colors.red.shade500,
          onTap: () {
            if(contactsBox.isNotEmpty){
              contactsBox.deleteFromDisk();
              SystemNavigator.pop();
            }
          },
        ),
      ],
    );
  }
}
