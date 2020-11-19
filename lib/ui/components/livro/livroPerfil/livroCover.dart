import 'package:flutter/material.dart';
import 'package:weebooks2/ui/shared/loading.dart';
import 'package:weebooks2/values/values.dart';

class LivroCover extends StatelessWidget {
  LivroCover({
    @required this.coverURL,
    this.width = 120,
    this.height = 170,
    this.loadingSize = 30,
    this.type = 0,
    this.boxFit = BoxFit.contain,
    this.borderRadius = 15,
  });

  final String coverURL;
  final double width;
  final double height;
  final double loadingSize;
  final int type;
  final BoxFit boxFit;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    bool isAsset = coverURL.contains('assets');

    return type == 0
        ? Container(
            width: width,
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: isAsset
                  ? Image.asset(
                      coverURL,
                      fit: boxFit,
                    )
                  : Image.network(
                      coverURL,
                      fit: boxFit,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: Loading(
                            color: primaryCyan,
                            opacity: false,
                            size: loadingSize,
                          ),
                        );
                      },
                    ),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: isAsset
                ? Image.asset(
                    coverURL,
                    fit: BoxFit.fill,
                  )
                : Image.network(
                    coverURL,
                    fit: BoxFit.fill,
                    frameBuilder: (BuildContext context, Widget child,
                        int frame, bool wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) {
                        return child;
                      }
                      return AnimatedOpacity(
                        child: child,
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
          );
  }
}
