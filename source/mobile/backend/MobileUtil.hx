package mobile.backend;

#if android
import extension.androidtools.os.Build.VERSION;
import extension.androidtools.os.Build.VERSION_CODES;
import extension.androidtools.os.Environment;
import extension.androidtools.Permissions;
import extension.androidtools.Settings;
#end

import lime.system.System;
import lime.app.Application;
import openfl.Assets;
import .Bytes;
import .Path;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

/** 
* @Authors MaysLastPlay, MarioMaster (MasterX-39), Dechis (dx7405), ArkoseLabs
* @version: 0.4.0
**/

class MobileUtil {
	public static var currentDirectory:String = null;

   /*
	 * Get the directory for the application. (External for Android Platform and Internal for iOS Platform.)
	 */

	public static function initDirectory():String {
		var daPath:String = '';
		daPath = #if android Path.addTrailingSlash("/sdcard/.ImpostorLegacy"); #elseif ios lime.system.System.documentsDirectory #end;
		currentDirectory = daPath;

		try
		{
			if (!FileSystem.exists(MobileUtil.getAssetDirectory()))
				FileSystem.createDirectory(MobileUtil.getAssetDirectory());
		}
		catch (e:Dynamic)
		{
			Application.current.window.alert("Looks like you doesn't have directory named\n" + MobileUtil.getAssetDirectory() +
			"\nBut maybe this couldn't be right, android loves to give errors like this\nPress OK & let's see what happens\nCurrent Error You Got:\n" + e, "Warning!");
		}

		try
		{
			if (!FileSystem.exists(MobileUtil.getDirectory() + "content/"))
				FileSystem.createDirectory(MobileUtil.getDirectory() + "content/");
		}
		catch (e:Dynamic)
		{
			Application.current.window.alert("Looks like you doesn't have directory named\n" + MobileUtil.getDirectory() + "mods/" + 
			"\nBut maybe this couldn't be right, android loves to give errors like this\nPress OK & let's see what happens\nCurrent Error You Got:\n" + e, "Warning!");
			//lime.system.System.exit(1);
		}

		return daPath;
	}

	public static inline function getAssetDirectory():String
		return #if android haxe.io.Path.addTrailingSlash("/sdcard/Android/data/com.motorfrog.impostor/files") #elseif ios lime.system.System.documentsDirectory #else Sys.getCwd() #end;

  public static function getDirectory():String
	{
		#if android	
		var _currentDirectory = currentDirectory;
		if (_currentDirectory == null || _currentDirectory == "") {
    	    trace("currentDirectory is null, initializing again...");
    	    _currentDirectory = initDirectory(); 
    	}
		return _currentDirectory;
		#elseif ios
		return LimeSystem.documentsDirectory;
		#else
		return Sys.getCwd();
		#end
	}

	/**
	 * Requests Storage Permissions on Android Platform.
	 */

	public static function getPermissions():Void
	{
		if (VERSION.SDK_INT >= VERSION_CODES.TIRAMISU)
			Permissions.requestPermissions([
				'READ_MEDIA_IMAGES',
				'READ_MEDIA_VIDEO',
				'READ_MEDIA_AUDIO',
				'READ_MEDIA_VISUAL_USER_SELECTED'
			]);
		else
			Permissions.requestPermissions(['READ_EXTERNAL_STORAGE', 'WRITE_EXTERNAL_STORAGE']);

		if (!Environment.isExternalStorageManager())
			Settings.requestSetting('MANAGE_APP_ALL_FILES_ACCESS_PERMISSION');
	}
	
		/**
	 * Saves a file to the external storage.
	 */
	
	public static function save(fileName:String = 'Ye', fileExt:String = '.txt', fileData:String = 'Nice try, but you failed, try again!', ?alert:Bool = true):Void
	{
		final folder:String = #if android MobileUtil.getDirectory() + #else Sys.getCwd() + #end 'saves/';
		try
		{
			if (!FileSystem.exists(folder))
				FileSystem.createDirectory(folder);

			File.saveContent('$folder/$fileName', fileData);
			if (alert)
				Application.current.window.alert('${fileName} has been saved.', "Success!");
		}
		catch (e:Dynamic)
			if (alert)
				Application.current.window.alert('${fileName} couldn\'t be saved.\n${e.message}', "Error!");
			else
				trace('$fileName couldn\'t be saved. (${e.message})');
	}
	
		/**
	 * @param folders Optional list of specific folders (e.g. ["assets/data/"]). If null, copies all assets.
	 */
	public static function copyAssets(folders:Array<String> = null, onProgress:String->Int->Int->Void = null, onComplete:Void->Void = null):Void {
		#if mobile
		var rootTarget = getAssetDirectory();
		try {
			var assetList:Array<String> = Assets.list();

			var toCopy = assetList.filter(function(assetKey) {
				var cleanPath = assetKey;
				var colonIndex = cleanPath.indexOf(":");
				if (colonIndex != -1) {
					cleanPath = cleanPath.substring(colonIndex + 1);
				}

				if (!StringTools.startsWith(cleanPath, "assets/")) return false;
				if (folders == null) return true;

				for (f in folders) {
					if (StringTools.startsWith(cleanPath, f)) return true;
				}
				return false;
			});

			var total = toCopy.length;
			if (total == 0) {
				if (onComplete != null) onComplete();
				return;
			}

			for (i in 0...total) {
				var assetKey = toCopy[i];

				var cleanPath = assetKey;
				var colonIndex = cleanPath.indexOf(":");
				if (colonIndex != -1) {
					cleanPath = cleanPath.substring(colonIndex + 1);
				}

				var fullPath = Path.join([rootTarget, cleanPath]);

				var directory = Path.directory(fullPath);
				if (!FileSystem.exists(directory)) FileSystem.createDirectory(directory);

				if (!FileSystem.exists(fullPath)) {
					var bytes:Bytes = null;

					try {
						bytes = Assets.getBytes(assetKey);
					} catch (e:Dynamic) {
						try {
							var text:String = Assets.getText(assetKey);
							if (text != null) {
								bytes = Bytes.ofString(text);
							}
						} catch (e2:Dynamic) {
							trace('Failed to read text fallback for $assetKey: $e2');
						}
					}

					if (bytes != null) {
						File.saveBytes(fullPath, bytes);
					} else {
						trace('Could not extract data for asset: $assetKey');
					}
				}

				if (onProgress != null) onProgress(cleanPath, i + 1, total);
			}

			if (onComplete != null) onComplete();
		} catch (e:Dynamic) {
			trace('Asset Copy Error: $e');
		}
		#end
	}
}
