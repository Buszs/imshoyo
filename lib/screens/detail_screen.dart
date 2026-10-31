import 'package:flutter/material.dart';
import 'package:flutter_playground/core/theme/app_colors.dart';
import 'package:flutter_playground/core/utils/trailer_launcher.dart';
import 'package:flutter_playground/data/models/media_detail.dart';
import 'package:flutter_playground/data/services/tmdb_service.dart';
import 'package:flutter_playground/widgets/media_parts.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  final bool isTv;

  const DetailScreen({super.key, required this.id, this.isTv = false});

  @override
  State<StatefulWidget> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _service = TmdbService();
  late Future<MediaDetail> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = _service.getMediaDetail(widget.id, isTv: widget.isTv);
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(6),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.onSurface,
            tooltip: 'Kembali',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceContainerLowest.withValues(
                alpha: 0.8,
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<MediaDetail>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.tertiary),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      size: 40,
                      color: AppColors.outline,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: text.bodySmall,
                    ),
                    TextButton(
                      onPressed: () => setState(_load),
                      child: Text(
                        'Coba lagi',
                        style: text.labelLarge?.copyWith(
                          color: AppColors.tertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return _DetailContent(detail: snapshot.data!);
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final MediaDetail detail;

  const _DetailContent({required this.detail});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final d = detail;
    final image = d.backdropUrl.isNotEmpty ? d.backdropUrl : d.posterUrl;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 11,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    TmdbImage(image),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.background,
                            AppColors.background.withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                          stops: const [0, 0.4, 1],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(d.title, style: text.headlineLarge),
                        ),
                        const SizedBox(width: 12),
                        RatingBadge(d.ratingText),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${d.metaText} • ${d.votesText}',
                      style: text.bodySmall,
                    ),
                    if (d.tagline != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        d.tagline!,
                        style: text.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppColors.tertiary,
                        ),
                      ),
                    ],

                    if (d.genres.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final g in d.genres)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant.withValues(
                                  alpha: 0.8,
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(g, style: text.labelSmall),
                            ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: () => openTrailer(context, d.trailerKey),
                        icon: const Icon(Icons.play_arrow_rounded, size: 24),
                        label: Text(
                          d.trailerKey != null
                              ? 'Tonton Trailer'
                              : 'Trailer Tidak Tersedia',
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.tertiaryFixed,
                          foregroundColor: AppColors.onTertiaryFixed,
                          shape: const StadiumBorder(),
                          textStyle: text.labelLarge,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text('Overview', style: text.headlineSmall),
                    const SizedBox(height: 8),
                    Text(
                      d.overview.isEmpty
                          ? 'Overview tidak tersedia'
                          : d.overview,
                      style: text.bodyMedium?.copyWith(height: 1.6),
                    ),

                    const SizedBox(height: 24),
                    Text('Info', style: text.headlineSmall),
                    const SizedBox(height: 8),
                    _InfoRow(
                      label: d.isTv ? 'First aired' : 'Release Date',
                      value: d.date,
                    ),
                    _InfoRow(label: 'Status', value: d.status),
                    if (d.isTv) ...[
                      _InfoRow(label: 'Seasons', value: '${d.seasons ?? '-'}'),
                      _InfoRow(
                        label: 'Episodes',
                        value: '${d.episodes ?? '-'}',
                      ),
                    ] else
                      _InfoRow(
                        label: 'Runtime',
                        value: d.durationText.isEmpty ? null : d.durationText,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: text.bodySmall)
          ),
          Expanded(
            child: Text(
              (value == null || value!.isEmpty) ? '-' : value!,
              style: text.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
