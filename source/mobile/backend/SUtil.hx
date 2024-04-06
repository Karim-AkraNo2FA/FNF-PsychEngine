package mobile.backend;

#if android
import android.content.Context as AndroidContext;
import android.os.Environment as AndroidEnvironment;
import android.Permissions as AndroidPermissions;
import android.Settings as AndroidSettings;
#end
#if sys
import sys.io.File;
import sys.FileSystem;
#end

/**
 * A storage class for mobile.
 * @author Mihai Alexandru (M.A. Jigsaw) and Lily (mcagabe19)
 */
class SUtil
{
	#if sys
	public static function getStorageDirectory(type:StorageType = #if OBB EXTERNAL_OBB #else EXTERNAL_DATA #end):String
	{
		var daPath:String = '';
		#if android
		switch (type)
		{
			case EXTERNAL_DATA:
				daPath = AndroidContext.getExternalFilesDir(null);
			case EXTERNAL_OBB:
				daPath = AndroidContext.getObbDir();
		}
		#elseif ios
		daPath = lime.system.System.documentsDirectory;
		#end

		return daPath;
	}

	public static function mkDirs(directory:String):Void
	{
		var total:String = '';
		if (directory.substr(0, 1) == '/')
			total = '/';

		var parts:Array<String> = directory.split('/');
		if (parts.length > 0 && parts[0].indexOf(':') > -1)
			parts.shift();

		for (part in parts)
		{
			if (part != '.' && part != '')
			{
				if (total != '' && total != '/')
					total += '/';

				total += part;

				try {
				if (!FileSystem.exists(total))
					FileSystem.createDirectory(total);
				}
				catch (e:haxe.Exception)
					throw 'Error while creating folder.\n(${e.message}\nTry restarting the game\n(Press OK to exit)';
			}
		}
	}

	public static function saveContent(fileName:String = 'file', fileExtension:String = '.json',
			fileData:String = 'You forgor to add somethin\' in yo code :3'):Void
	{
		try
		{
			if (!FileSystem.exists('saves'))
				FileSystem.createDirectory('saves');

			File.saveContent('saves/' + fileName + fileExtension, fileData);
			showPopUp(fileName + " file has been saved.", "Success!");
		}
		catch (e:haxe.Exception)
			trace('File couldn \'t be saved. (${e.message})');
	}
	#end

	public static function showPopUp(message:String, title:String):Void
	{
		#if (!ios || !iphonesim)
		lime.app.Application.current.window.alert(message, title);
		#else
		trace('$title - $message');
		#end
	}
}

enum StorageType
{
	EXTERNAL_DATA;
	EXTERNAL_OBB;
}

