import 'dart:async';

import 'package:examle/netease/netease_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nertc_core/nertc_core.dart';

class VideoRenderCache {
  // if use cached render, the last frame of that render may be shown
  static const kEnableCache = false;

  final int maxSize;
  final renderers = <NERtcVideoRenderer>{};

  int created = 0;
  final pending = <Completer<NERtcVideoRenderer>>[];

  VideoRenderCache(this.maxSize);

  Future<NERtcVideoRenderer> pop() async {
    if (!kEnableCache) {
      return NERtcVideoRendererFactory.createVideoRenderer();
    }
    if (renderers.isNotEmpty) {
      final renderer = renderers.first;
      renderers.remove(renderer);
      return renderer;
    }
    if (created < maxSize) {
      created++;
      return NERtcVideoRendererFactory.createVideoRenderer();
    }
    final completer = Completer<NERtcVideoRenderer>();
    pending.add(completer);
    assert(() {
      return true;
    }());
    return completer.future;
  }

  Future<void> push(NERtcVideoRenderer? render) async {
    if (render != null) {
      if (!kEnableCache) {
        await render.dispose();
        return;
      }
      assert(() {
        return true;
      }());
      if (pending.isNotEmpty) {
        pending.removeAt(0).complete(render);
      } else if (renderers.length >= maxSize) {
        await render.dispose();
      } else {
        renderers.add(render);
      }
    }
  }

  Future<void> clear() async {
    final values = renderers.toList();
    renderers.clear();
    for (var value in values) {
      await value.dispose();
    }
    created = 0;
  }
}

/// Use this widget to ensure that the renderer is created only once.
/// And the renderer will be disposed when the widget is unmounted.
/// This make sure that one creation is corresponding to one dispose without leak.
class NERtcVideoViewX extends StatefulWidget {
  final int? uid; // null for local
  final bool subStream;
  final ValueListenable<bool>? mirrorListenable;

  final NERtcVideoViewFitType fitType;
  final WidgetBuilder? placeholderBuilder;

  const NERtcVideoViewX({
    Key? key,
    this.uid,
    this.subStream = false,
    this.mirrorListenable,
    this.fitType = NERtcVideoViewFitType.cover,
    this.placeholderBuilder,
  }) : super(key: key);

  @override
  State<NERtcVideoViewX> createState() => _NERtcVideoViewXState();
}

class _NERtcVideoViewXState extends State<NERtcVideoViewX> {
  NERtcVideoRenderer? _renderer;
  var _creating = false;

  void _initRenderer() async {
    if (_renderer != null || _creating) {
      return;
    }
    _creating = true;
    final render = await NeteaseUtils.videoRenderCache.pop();
    if (mounted) {
      setState(() {
        _renderer = render;
        _attachRender();
      });
    } else {
      await NeteaseUtils.videoRenderCache.push(render);
    }
    _creating = false;
  }

  void _disposeRenderer() {
    NeteaseUtils.videoRenderCache.push(_renderer);
    _renderer = null;
  }

  void _attachRender() async {
    final render = _renderer;
    if (render != null) {
      final uid = widget.uid;
      final subStream = widget.subStream;
      if (uid == null) {
        await (!subStream
            ? render.attachToLocalVideo()
            : render.attachToLocalSubStreamVideo());
      } else {
        await (!subStream
            ? render.attachToRemoteVideo(uid)
            : render.attachToRemoteSubStreamVideo(uid));
      }
      _updateMirror();
    }
  }

  void _updateMirror() {
    if (_renderer != null && widget.mirrorListenable != null) {
      _renderer!.setMirror(widget.mirrorListenable!.value);
    }
  }

  @override
  void initState() {
    super.initState();
    _initRenderer();
    widget.mirrorListenable?.addListener(_updateMirror);
  }

  @override
  void dispose() {
    _disposeRenderer();
    super.dispose();
  }

  @override
  void didUpdateWidget(NERtcVideoViewX oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.uid != oldWidget.uid ||
        widget.subStream != oldWidget.subStream) {
      _disposeRenderer();
      _initRenderer();
    }
    if (widget.mirrorListenable != oldWidget.mirrorListenable) {
      oldWidget.mirrorListenable?.removeListener(_updateMirror);
      widget.mirrorListenable?.addListener(_updateMirror);
    }
  }

  @override
  Widget build(BuildContext context) {
    final render = _renderer;
    return render != null
        ? NERtcVideoView(renderer: render, fitType: widget.fitType)
        : widget.placeholderBuilder?.call(context) ??
            Container(color: Colors.transparent);
  }
}
