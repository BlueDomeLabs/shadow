import '../../domain/cloud/cloud_storage_provider.dart';
import '../../domain/sync/sync_metadata.dart';
import 'google_drive_provider.dart';
import '../cloud_providers/icloud_storage_provider.dart';

/// Factory for creating the appropriate cloud storage provider
class CloudProviderFactory {
  static CloudStorageProvider? _googleDriveProvider;
  static CloudStorageProvider? _iCloudProvider;

  /// Get the appropriate cloud provider based on the provider type
  static CloudStorageProvider getProvider(CloudProvider type) {
    switch (type) {
      case CloudProvider.googleDrive:
        _googleDriveProvider ??= GoogleDriveProvider();
        return _googleDriveProvider!;

      case CloudProvider.icloud:
        _iCloudProvider ??= ICloudStorageProvider();
        return _iCloudProvider!;

      case CloudProvider.none:
        throw CloudStorageException('No cloud provider selected');
    }
  }

  /// Reset providers (useful for testing or switching accounts)
  static void reset() {
    _googleDriveProvider = null;
    _iCloudProvider = null;
  }
}
