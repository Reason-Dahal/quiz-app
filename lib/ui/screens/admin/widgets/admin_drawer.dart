import 'package:flutter/material.dart';
import 'package:quiz_app/core/services/auth_service.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Center(child: Icon(Icons.admin_panel_settings, size: 70)),
          ),

          // ListTile(
          //   leading: const Icon(Icons.home),
          //   title: const Text("Home"),
          //   onTap: () {
          //     Navigator.pushNamedAndRemoveUntil(
          //       context,
          //       "/home",
          //       (route) => false,
          //     );
          //   },
          // ),

          // ListTile(
          //   leading: const Icon(Icons.admin_panel_settings),
          //   title: const Text("Admin"),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          // const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Center(child: Text("LogOut")),
                    content: Text("Do you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancle"),
                      ),
                      TextButton(
                        onPressed: () async {
                          await auth.signOut();

                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              "/auth",
                              (route) => false,
                            );
                          }
                        },
                        child: Text("LogOut"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
/*                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Center(child: Text("LogOut")),
                      content: Text("Do you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancle"),
                        ),
                        TextButton(
                          onPressed: () async {
              await auth.signOut();

              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/auth",
                  (route) => false,
                );
              }
            },
                          child: Text("LogOut"),
                        ),
                      ],
                    );
                  },
                ); */