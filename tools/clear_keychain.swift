// tools/clear_keychain.swift
// Clears all flutter_secure_storage items from the Data Protection Keychain.
// Used by factory-reset since the `security` CLI tool cannot access these items.
//
// Build: swiftc tools/clear_keychain.swift -o tools/clear_keychain
// Run:   ./tools/clear_keychain

import Foundation
import Security

let query: [CFString: Any] = [
    kSecClass: kSecClassGenericPassword,
    kSecAttrService: "flutter_secure_storage_service",
    kSecUseDataProtectionKeychain: true,
]

let status = SecItemDelete(query as CFDictionary)

switch status {
case errSecSuccess:
    print("OK: Cleared all flutter_secure_storage items from Data Protection Keychain")
case errSecItemNotFound:
    print("OK: No flutter_secure_storage items found in Data Protection Keychain")
default:
    print("WARNING: SecItemDelete returned status \(status)")
}

// Also clear legacy keychain items (belt and suspenders)
let legacyQuery: [CFString: Any] = [
    kSecClass: kSecClassGenericPassword,
    kSecAttrService: "flutter_secure_storage_service",
]

let legacyStatus = SecItemDelete(legacyQuery as CFDictionary)
if legacyStatus == errSecSuccess {
    print("OK: Also cleared legacy keychain items")
}
