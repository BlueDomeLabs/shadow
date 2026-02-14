// lib/presentation/screens/home/tabs/photos_tab.dart
// Photo tracking tab with grid of photo area cards.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/presentation/providers/photo_areas/photo_area_list_provider.dart';
import 'package:shadow_app/presentation/providers/photo_entries/photo_entries_by_area_provider.dart';
import 'package:shadow_app/presentation/screens/photo_areas/photo_area_list_screen.dart';
import 'package:shadow_app/presentation/screens/photo_entries/photo_entry_gallery_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Photos tab showing photo areas in a grid with photo counts.
class PhotosTab extends ConsumerWidget {
  final String profileId;
  final String? profileName;

  const PhotosTab({super.key, required this.profileId, this.profileName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final areasAsync = ref.watch(photoAreaListProvider(profileId));
    final titlePrefix = profileName != null ? "$profileName's " : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('${titlePrefix}Photo Tracking'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => PhotoAreaListScreen(profileId: profileId),
                  ),
                ),
                icon: const Icon(Icons.edit_location_alt),
                label: const Text('Manage Photo Areas'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: areasAsync.when(
              data: (areas) {
                if (areas.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No photo areas defined',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Set up areas to track with photos',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: areas.length,
                  itemBuilder: (context, index) {
                    final area = areas[index];
                    final photosAsync = ref.watch(
                      photoEntriesByAreaProvider(profileId, area.id),
                    );
                    final count =
                        photosAsync.whenOrNull(
                          data: (entries) => entries.length,
                        ) ??
                        0;

                    return Semantics(
                      button: true,
                      label: '${area.name}, $count photos',
                      hint: 'Double tap to view photo gallery',
                      child: Card(
                        elevation: 2,
                        child: InkWell(
                          onTap: () => Navigator.of(context).push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => PhotoEntryGalleryScreen(
                                profileId: profileId,
                                photoArea: area,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ExcludeSemantics(
                                  child: Icon(
                                    Icons.photo_library,
                                    size: 40,
                                    color: Colors.purple[300],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ExcludeSemantics(
                                  child: Text(
                                    area.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ExcludeSemantics(
                                  child: Text(
                                    '$count photos',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: ShadowStatus.loading(label: 'Loading photo areas'),
              ),
              error: (error, _) =>
                  Center(child: Text('Error loading photo areas: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
