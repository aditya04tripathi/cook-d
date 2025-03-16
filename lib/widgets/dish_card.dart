import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

Widget DishCard(BuildContext context, {required data}) {
  return Container(
    decoration: BoxDecoration(),
    child: ClipRRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          data["image"].isNotEmpty
              ? Image(
                image: CachedNetworkImageProvider(data["image"]),
                fit: BoxFit.cover,
                width: 250,
                height: 250,
              )
              : Image.asset(
                'assets/images/can_tower.jpg',
                fit: BoxFit.cover,
                width: 250,
                height: 250,
              ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 125,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.black.withAlpha(128),
                    Colors.transparent,
                  ],
                  stops: [0, 0.5, 1],
                ),
              ),
            ),
          ),

          Positioned(
            top: 20,
            right: 20,
            height: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width * 0.3,
                    maxHeight: 30,
                  ),
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "📍 ${data["location"]} ⏰ in ${data["time"]}m",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black.withAlpha(128),
                    Colors.transparent,
                  ],
                  stops: [0, 0.8, 1],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    data["name"],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          minimumSize: Size(
                            (MediaQuery.of(context).size.width * 0.4)
                                .toDouble(),
                            50,
                          ),
                          maximumSize: Size(
                            (MediaQuery.of(context).size.width * 0.8)
                                .toDouble(),
                            50,
                          ),
                        ),
                        child: Text(
                          'COUNT ME IN (${data["spots"]}/10)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        style: IconButton.styleFrom(minimumSize: Size(50, 50)),
                        onPressed: () {},
                        icon: Column(
                          children: [
                            Text(
                              "🔥",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              (new Random().nextInt(15) + 5).toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 0,
            bottom: 0,
            right: 20,
            child: Icon(Icons.arrow_back_rounded, size: 60, color: Colors.white)
                .animate(
                  autoPlay: true,
                  onPlay: (controller) => controller.repeat(),
                )
                .moveX(
                  begin: 0,
                  end: 10,
                  duration: 500.milliseconds,
                  curve: Curves.easeInOut,
                )
                .then()
                .moveX(
                  begin: 10,
                  end: 0,
                  duration: 500.milliseconds,
                  curve: Curves.easeInOut,
                ),
          ),
        ],
      ),
    ),
  );
}
