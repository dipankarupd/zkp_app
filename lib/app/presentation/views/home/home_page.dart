import 'package:flutter/material.dart';
import 'package:zkp_app/app/domain/entity/register_user_entity.dart';

class HomePageNew extends StatelessWidget {
  const HomePageNew({super.key});

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments as UserEntity?;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text('Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/man.jpg'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  user!.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Text(
                        'Last checked in at: ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.lastChecked != null
                            ? user.lastChecked!.toIso8601String()
                            : 'Not checked in',
                        style: TextStyle(
                          color: user.lastChecked != null
                              ? Colors.brown[500]
                              : Colors.red, // Red if null
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Attendance History',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Present: ',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          user.presentCount.toString(),
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Absent: ',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          user.absentCount.toString(),
                          style: TextStyle(
                            color: Colors.red[800],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 80,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Mark Attendance',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
