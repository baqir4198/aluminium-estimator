import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/opening.dart';
import '../models/size_line.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class OpeningPreview extends StatelessWidget {
  const OpeningPreview({
    super.key,
    required this.type,
    required this.widthFt,
    required this.heightFt,
    required this.frameColor,
    required this.caption,
  });

  final OpeningType type;
  final double widthFt;
  final double heightFt;
  final Color frameColor;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
      'Preview of ${type.label}, ${SizeLine.formatFt(widthFt)} by ${SizeLine.formatFt(heightFt)} feet',
      child: Container(
        height: 168,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox.expand(
                  child: CustomPaint(
                    painter: _OpeningPainter(
                      type: type,
                      widthFt: widthFt,
                      heightFt: heightFt,
                      frameColor: frameColor,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14,
              top: 10,
              child: Text(
                caption,
                style: bodyStyle(12, weight: FontWeight.w600, color: AppColors.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpeningPainter extends CustomPainter {
  _OpeningPainter({
    required this.type,
    required this.widthFt,
    required this.heightFt,
    required this.frameColor,
  });

  final OpeningType type;
  final double widthFt;
  final double heightFt;
  final Color frameColor;

  static const _line = Color(0xFF8A96A1);
  static const _paneStroke = Color(0xFF9AA5AE);

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 34.0, topPad = 26.0, rightPad = 34.0, bottomPad = 22.0;
    final avail = Rect.fromLTRB(
      leftPad,
      topPad,
      size.width - rightPad,
      size.height - bottomPad,
    );
    if (avail.width <= 0 || avail.height <= 0) return;

    final w = widthFt > 0 ? widthFt : 1.0;
    final h = heightFt > 0 ? heightFt : 1.0;
    final scale = math.min(avail.width / w, avail.height / h);
    final frame = Rect.fromCenter(
      center: avail.center,
      width: w * scale,
      height: h * scale,
    );
    final border = math.min(7.0, math.min(frame.width, frame.height) / 4);
    final inner = frame.deflate(border);

    canvas.drawRect(frame, Paint()..color = frameColor);
    canvas.drawRect(
      frame,
      Paint()
        ..color = _line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    switch (type) {
      case OpeningType.slidingWindow:
        _sliding(canvas, inner);
      case OpeningType.fixedGlass:
        _pane(canvas, inner, const Color(0xFFCFE0E8));
      case OpeningType.door:
        _door(canvas, inner);
    }

    _dimensions(canvas, frame, size);
  }

  void _pane(Canvas canvas, Rect r, Color fill) {
    canvas.drawRect(r, Paint()..color = fill);
    canvas.drawRect(
      r,
      Paint()
        ..color = _paneStroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _sliding(Canvas canvas, Rect inner) {
    final mid = inner.center.dx;
    final right = Rect.fromLTRB(mid - 3, inner.top, inner.right, inner.bottom);
    final left = Rect.fromLTRB(inner.left, inner.top, mid + 3, inner.bottom);
    _pane(canvas, right, const Color(0xFFCFE0E8));
    _pane(canvas, left, const Color(0xFFDCE9EF));

    if (left.width > 36 && left.height > 24) {
      final y = left.center.dy;
      final x1 = left.left + 10;
      final x2 = left.right - 14;
      final p = Paint()
        ..color = AppColors.muted
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(x1, y), Offset(x2, y), p);
      canvas.drawLine(Offset(x2 - 6, y - 5), Offset(x2, y), p);
      canvas.drawLine(Offset(x2 - 6, y + 5), Offset(x2, y), p);
    }
  }

  void _door(Canvas canvas, Rect inner) {
    final glass = Rect.fromLTWH(inner.left, inner.top, inner.width, inner.height * 0.58);
    final panel = Rect.fromLTRB(inner.left, glass.bottom + 2, inner.right, inner.bottom);
    _pane(canvas, glass, const Color(0xFFCFE0E8));
    canvas.drawRect(panel, Paint()..color = frameColor);
    canvas.drawRect(
      panel,
      Paint()
        ..color = _paneStroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(
      Offset(inner.right - 10, inner.center.dy),
      3,
      Paint()..color = AppColors.ink,
    );
  }

  void _dimensions(Canvas canvas, Rect frame, Size size) {
    final line = Paint()
      ..color = _line
      ..strokeWidth = 1.5;

    final ty = frame.top - 10;
    canvas.drawLine(Offset(frame.left, ty), Offset(frame.right, ty), line);
    canvas.drawLine(Offset(frame.left, ty - 5), Offset(frame.left, ty + 5), line);
    canvas.drawLine(Offset(frame.right, ty - 5), Offset(frame.right, ty + 5), line);
    _text(canvas, '${SizeLine.formatFt(widthFt)} ft', Offset(frame.center.dx, ty - 9));

    final lx = frame.left - 10;
    canvas.drawLine(Offset(lx, frame.top), Offset(lx, frame.bottom), line);
    canvas.drawLine(Offset(lx - 5, frame.top), Offset(lx + 5, frame.top), line);
    canvas.drawLine(Offset(lx - 5, frame.bottom), Offset(lx + 5, frame.bottom), line);
    _text(
      canvas,
      '${SizeLine.formatFt(heightFt)} ft',
      Offset(lx - 10, frame.center.dy),
      angle: -math.pi / 2,
    );

    if (widthFt > 0 && heightFt > 0) {
      _text(
        canvas,
        '${SizeLine.formatFt(widthFt * heightFt)} sq ft',
        Offset(size.width / 2, size.height - 10),
      );
    }
  }

  void _text(Canvas canvas, String text, Offset center, {double angle = 0}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: bodyStyle(13, weight: FontWeight.w600, color: AppColors.muted),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OpeningPainter old) =>
      old.type != type ||
          old.widthFt != widthFt ||
          old.heightFt != heightFt ||
          old.frameColor != frameColor;
}