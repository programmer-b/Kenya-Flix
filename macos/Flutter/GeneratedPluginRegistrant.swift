//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import awesome_notifications
import connectivity_plus_macos
import nb_utils
import path_provider_macos
import shared_preferences_macos
import sqflite
import wakelock_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AwesomeNotificationsPlugin.register(with: registry.registrar(forPlugin: "AwesomeNotificationsPlugin"))
  ConnectivityPlugin.register(with: registry.registrar(forPlugin: "ConnectivityPlugin"))
  NbUtilsPlugin.register(with: registry.registrar(forPlugin: "NbUtilsPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  WakelockMacosPlugin.register(with: registry.registrar(forPlugin: "WakelockMacosPlugin"))
}
