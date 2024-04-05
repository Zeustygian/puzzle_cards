package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.display.SpreadMethod;
import openfl.display.Sprite;

class MenuState extends FlxState
{
	var background:FlxSprite;
	var title:FlxText;
	var blinkTime:Float = 0;

	override public function create()
	{
		super.create();

		background = new FlxSprite();
		background.loadGraphic(AssetPaths.background__png);
		background.scale.set(FlxG.width / background.width, FlxG.height / background.height);
		background.updateHitbox();
		add(background);
		var buttonPlay:FlxButtonPlus = new FlxButtonPlus(0, 0, function()
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
			{
				FlxG.switchState(new PlayState());
			});
		}, "PLAY", 176, 32);
		buttonPlay.x = FlxG.width / 2 - buttonPlay.width / 2;
		buttonPlay.y = FlxG.height / 2 - buttonPlay.height / 2 + 30;
		buttonPlay.textNormal.y = buttonPlay.y + 10;
		buttonPlay.textHighlight.y = buttonPlay.y + 10;
		add(buttonPlay);

		// FlxG.sound.playMusic(AssetPaths.Buy_Something_Will_Ya__ogg, 0.8, true);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
